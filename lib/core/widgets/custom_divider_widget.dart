import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDividerWidget extends StatelessWidget {
  const CustomDividerWidget({super.key, this.padding});
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      width: double.infinity,
      margin: padding,
      decoration: BoxDecoration(
        color: context.colors.textSubtle,
      ),
    );
  }
}
