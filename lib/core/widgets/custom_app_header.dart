import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/config/res/color_manager.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/custom_text.dart';

class CustomAppHeader extends StatelessWidget {
  const CustomAppHeader({
    super.key,
    required this.title,
    this.height,
    this.spaceTop,
    this.backWidth,
    this.backHeight,
    this.onBack,
    this.vectorPath,
    this.color,
    this.backColor,
    this.backMargin,
    this.actions,
    this.leading,
    this.showBackButton = true,
  });

  final String title;
  final double? height, spaceTop, backWidth, backHeight;
  final VoidCallback? onBack;
  final String? vectorPath;
  final Color? color, backColor;
  final EdgeInsets? backMargin;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height ?? AppSize.sH120,
            decoration: BoxDecoration(
              color: color ?? AppColors.primary,
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(AppRadius.bR10),
                bottomEnd: Radius.circular(AppRadius.bR10),
              ),
              // image: DecorationImage(
              //   image: ExactAssetImage(
              //     vectorPath ?? 'assets/images/appbar.png',
              //   ),
              //   fit: BoxFit.cover,
              // ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(height: spaceTop ?? AppSize.sH55),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (leading != null)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: GestureDetector(
                          onTap: onBack ?? () => Navigator.pop(context),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 10.0.w),
                            child: leading,
                          ),
                        ),
                      ),
                    if (showBackButton)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: GestureDetector(
                          onTap: onBack ?? () => Navigator.pop(context),
                          child: Container(
                            width: backWidth ?? AppSize.sW40,
                            height: backHeight ?? AppSize.sW40,
                            margin:
                                backMargin ??
                                const EdgeInsetsDirectional.fromSTEB(
                                  16,
                                  12,
                                  0,
                                  6,
                                ),
                            decoration: BoxDecoration(
                              color: backColor ?? context.colors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppRadius.bR10,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                size: 28.sp,
                                color: context.colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (actions != null) const Spacer(),
                        Center(
                          child: CustomText.headlineMedium(
                            title,
                            textAlign: TextAlign.center,
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: context.colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (actions != null) ...[...actions!],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
