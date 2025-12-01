import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScrollBarWidget extends StatelessWidget {
  final Widget child;
  const ScrollBarWidget({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 12.w,
      interactive: true,
      radius: Radius.circular(16.r),
      thumbVisibility: true,
      trackVisibility: true,
      child: child,
    );
  }
}
