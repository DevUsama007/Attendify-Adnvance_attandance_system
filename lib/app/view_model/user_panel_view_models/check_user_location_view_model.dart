import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class CheckUserLocationViewModel extends GetxController {
  RxString address = 'processing...'.obs;
  RxBool varifying = false.obs;
  RxBool gettingUserLocation = false.obs;

  updatelocation(String location) {
    address.value = location;
  }

  toggleGettingUserLocation(bool value) {
    gettingUserLocation.value = value;
  }

  toggleVarifying(bool value) {
    varifying.value = value;
  }

  getuserlocation(double latitude, double longitude) async {
    print(
        '------------------------------------Location updated to: ${address}');
    placemarkFromCoordinates(latitude, longitude).then(
      (_place) {
        Placemark place = _place.first;

        // Try to get the most specific name available
        String? locationName = place.name?.isNotEmpty == true
            ? place.name
            : place.street?.isNotEmpty == true
                ? place.street
                : place.locality ?? 'Unknown Location';

        String fullAddress =
            '${locationName}, ${place.locality}, ${place.administrativeArea}';

        print('Location: $locationName');
        print('Full address: $fullAddress');

        updatelocation(fullAddress);
      },
    ).onError(
      (error, stackTrace) {
        print('Error occurred while fetching location: $error');
      },
    );
  }
}
