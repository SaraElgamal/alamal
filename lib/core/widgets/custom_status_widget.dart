import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:charity_app/core/config/res/constants_manager.dart';
import 'package:charity_app/core/helpers/context_extension.dart';

class CustomStatusWidget extends StatelessWidget {
  const CustomStatusWidget({
    super.key,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.onTap,
  });

  final String? title;
  final Color? titleColor, backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 7.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: backgroundColor,
        ),
        child: Text(
          title ?? '',
          style: TextStyle(
            fontSize: 14.sp,
            color: titleColor ?? context.colors.background,
            fontWeight: FontWeight.w500,
            fontFamily: ConstantManager.fontFamily,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
