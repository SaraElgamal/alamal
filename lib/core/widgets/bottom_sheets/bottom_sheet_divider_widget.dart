import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetDividerWidget extends StatelessWidget {
  const BottomSheetDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: 130.w,
      margin: EdgeInsets.only(top: 18.h, bottom: 17.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: context.colors.black10,
      ),
    );
  }
}
