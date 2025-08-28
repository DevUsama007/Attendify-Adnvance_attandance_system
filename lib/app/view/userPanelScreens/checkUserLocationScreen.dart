import 'dart:async';
import 'dart:collection';
import 'package:attendify/app/custom_widget/loading_indicator_widget.dart';
import 'package:attendify/app/res/routes/routes_name.dart';
import 'package:attendify/app/utils/notificatinoUtils.dart';
import 'package:attendify/app/view_model/user_panel_view_models/check_user_location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';

import '../../res/appTextStyles.dart';
import '../../res/app_colors.dart';
import '../cameraScreens/camera_view.dart';

class CheckUserLocationScreen extends StatefulWidget {
  String btn_text;
  CheckUserLocationScreen({super.key, required this.btn_text});

  @override
  State<CheckUserLocationScreen> createState() =>
      _CheckUserLocationScreenState();
}

class _CheckUserLocationScreenState extends State<CheckUserLocationScreen> {
  CheckUserLocationViewModel _checkUserLocationController =
      Get.put(CheckUserLocationViewModel());
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController; // Add this variable

  final Set<Polygon> _polygons = HashSet<Polygon>();
  final Set<Marker> _markers = {};
  final location = Location();
  late PermissionStatus _permissionGranted;
  List<LatLng> points = [
    LatLng(30.635992, 72.947610),
    LatLng(30.602606, 72.950013),
    LatLng(30.594479, 72.916883),
    LatLng(30.596400, 72.890103),
    LatLng(30.607777, 72.867101),
    LatLng(30.628607, 72.884439),
    LatLng(30.640423, 72.906411),
    LatLng(30.635992, 72.947610)
  ];

  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(30.611368946515537, 72.89296023714256),
    zoom: 14,
  );
  updateLocationInAddress() async {
    _checkUserLocationController.toggleVarifying(true);
    _checkUserLocationController.toggleGettingUserLocation(true);

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null; // Permission denied
      }
    }
    LocationData _locationData = await location.getLocation();
    // Update camera position
    final newCameraPosition = CameraPosition(
      target: LatLng(_locationData.latitude!, _locationData.longitude!),
      zoom: 14,
    );
// Animate camera to new position if controller is available
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(newCameraPosition),
      );
    }
    LatLng userLocation = LatLng(_locationData.latitude!,
        _locationData.longitude!); // Add marker for user location
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId("user_marker"),
        position: userLocation,
      ));
    });
    await _checkUserLocationController
        .getuserlocation(_locationData.latitude!, _locationData.longitude!)
        .then((value) {
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('polygon_1'),
          points: points,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 2,
        ),
      );
      setState(() {});
    });
    _checkUserLocationController.toggleVarifying(false);
    _checkUserLocationController.toggleGettingUserLocation(false);
  }

  Future<void> _checkUserLocation(BuildContext context) async {
    _checkUserLocationController.toggleVarifying(true);
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null; // Permission denied
      }

      _checkUserLocationController.toggleVarifying(false);
    }

    // Get current location
    LocationData _locationData = await location.getLocation();
    LatLng userLocation =
        LatLng(_locationData.latitude!, _locationData.longitude!);
    // Move camera to user location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(userLocation),
      );
    }
    // Check if inside polygon
    if (_isPointInPolygon(userLocation, points)) {
      _checkUserLocationController.toggleVarifying(false);
      NotificationUtils.showSnackBar(
          context, "Success", "You are inside office building", true);
      Get.to(() => CameraView(
            session: widget.btn_text.toString().toLowerCase(),
          ));
      //navigate to the camera screen
    } else {
      _checkUserLocationController.toggleVarifying(false);
      NotificationUtils.showSnackBar(
          context, "Error", "You are outside Office Building", false);
    }
  }

  /// Ray-casting algorithm for "point in polygon"
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length - 1; j++) {
      if (rayCastIntersect(point, polygon[j], polygon[j + 1])) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1; // odd = inside, even = outside
  }

  bool rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = point.latitude;
    double pX = point.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false;
    }

    double m = (bY - aY) / (bX - aX);
    double bee = (-aX) * m + aY;
    double x = (pY - bee) / m;

    return x > pX;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateLocationInAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            polygons: _polygons,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _mapController = controller;
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: Get.width * 0.9,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.scafoldSecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.iconColor,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Location',
                            style: AppTextStyles.customText(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: AppColors.textPrimaryDark.withOpacity(0.6),
                            ),
                          ),
                          Obx(
                            () {
                              return Text(
                                _checkUserLocationController.address.value
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.customTextbolddark14(),
                              );
                            },
                          )
                        ],
                      ).paddingOnly(left: 30, top: 10),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 25,
              left: 10,
              child: InkWell(
                onTap: _checkUserLocationController.gettingUserLocation.value
                    ? () {}
                    : () {
                        _checkUserLocation(context);
                      },
                child: Container(
                  width: Get.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      widget.btn_text.toString(),
                      style: AppTextStyles.customTextbolddark14(),
                    ),
                  ),
                ),
              )),
          Obx(
            () => Positioned(
                top: Get.height * 0.45,
                left: Get.width * 0.2,
                child: _checkUserLocationController.varifying.value
                    ? _checkUserLocationController.gettingUserLocation.value
                        ? _verifyingLocationWidget(
                            message: 'Geting Location...')
                        : _verifyingLocationWidget()
                    : Container()),
          )
        ],
      ),
    );
  }
}

Widget _verifyingLocationWidget({String message = 'Verifying Location...'}) {
  return Container(
    width: Get.width * 0.6,
    height: 90,
    decoration: BoxDecoration(
      color: AppColors.scaffoldDark.withOpacity(0.7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          style: AppTextStyles.customTextbolddark14(),
        ),
        SizedBox(
          height: 8,
        ),
        LoadingIndicatorWidget(
            strokeWidth: 0.2,
            width: Get.width * 0.3,
            height: Get.height * 0.03,
            indicator: Indicator.ballPulse,
            indicatorColor: AppColors.iconColor)
      ],
    ),
  );
}
