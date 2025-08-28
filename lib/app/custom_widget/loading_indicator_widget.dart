import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get/get.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final Indicator indicator;
  final Color indicatorColor;
  final double strokeWidth;
  final double? width;
  final double? height;
  final Color backgroundclr;
  LoadingIndicatorWidget({
    super.key,
    required this.indicator,
    required this.indicatorColor,
    this.strokeWidth = 2,
    this.backgroundclr = Colors.red,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width * 0.9, // use provided width or default
      height: height, // use provided height or null (let child determine)
      child: Transform.scale(
        scale: 0.4,
        child: LoadingIndicator(
          indicatorType: indicator,
          colors: [indicatorColor, Colors.yellowAccent, Colors.greenAccent],
          // backgroundColor: AppColors.iconColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
