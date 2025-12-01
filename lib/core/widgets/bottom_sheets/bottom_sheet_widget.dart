import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/bottom_sheets/bottom_sheet_divider_widget.dart';
import 'package:charity_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    super.key,
    this.height,
    this.title,
    required this.child,
    this.titleStyle,
    this.colorBottomSheet,
    this.button,
    this.isDivider = true,
  });

  final double? height;
  final String? title;
  final Widget child;
  final TextStyle? titleStyle;
  final Color? colorBottomSheet;
  final bool isDivider;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: colorBottomSheet ?? context.colors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          isDivider ? const BottomSheetDividerWidget() : Container(),
          if (title != null)
            CustomText.headlineMedium(
              title!,
              textStyle: titleStyle ??
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: context.colors.text,
                      ),
            ),
          if (title != null) SizedBox(height: 20.h),
          Flexible(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
          if (button != null) ...[
            button!,
            SizedBox(height: 30.h),
          ]
        ],
      ),
    );
  }
}
