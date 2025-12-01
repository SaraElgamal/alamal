import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:charity_app/core/helpers/context_extension.dart';

class ExpansionWidget extends StatelessWidget {
  const ExpansionWidget({
    super.key,
    required this.title,
    required this.children,
    this.titleStyle,
    this.iconColor,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  final String title;
  final List<Widget> children;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final bool? initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: context.colors.whiteF4F5F6,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.black20),
      ),
      child: ExpansionTile(
        onExpansionChanged: onExpansionChanged,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.colors.black20),
        ),
        initiallyExpanded: initiallyExpanded ?? true,
        childrenPadding: EdgeInsets.zero,
        tilePadding: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 0, bottom: 0),
        title: Text(
          title,
          style:
              titleStyle ??
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.black80,
              ),
        ),
        backgroundColor: context.colors.whiteF4F5F6,
        iconColor: iconColor ?? context.colors.black80,
        collapsedIconColor: iconColor ?? context.colors.black80,
        children: children,
      ),
    );
  }
}
