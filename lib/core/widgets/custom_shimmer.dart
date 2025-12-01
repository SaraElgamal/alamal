import 'package:flutter/material.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final Color? baseColor;
  final Color? highlightColor;
  final double? margin;
  final BorderRadius? borderRadius;

  const CustomShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.baseColor,
    this.highlightColor,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin ?? AppMargin.mH10),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(AppCircular.r5),
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
