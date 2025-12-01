import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isCenter;
  final bool isLeading;
  final String? title;
  final String? subTitle;
  final Widget? leading;
  final double? marginStart;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final VoidCallback? onTapLeading;

  const CustomAppBar({
    super.key,
    this.isCenter = true,
    this.isLeading = true,
    this.title,
    this.subTitle,
    this.leading,
    this.marginStart,
    this.actions,
    this.backgroundColor,
    this.onTapLeading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? context.colors.background,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 58,
      leading: (isLeading)
          ? leading ??
              GestureDetector(
                onTap: onTapLeading ?? () => context.pop(),
                child: Container(
                  width: AppSize.sW40,
                  height: AppSize.sH40,
                  margin: EdgeInsetsDirectional.fromSTEB(marginStart ?? 16, 12, 0, 6),
                  decoration: BoxDecoration(
                    color: context.colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 32.sp,
                      color: context.colors.text,
                    ),
                  ),
                ),
              )
          : const SizedBox(),
      title: (title != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText.headlineMedium(
                  title!,
                  textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: context.colors.text,
                         fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                      ),
                ),
                if (subTitle != null) SizedBox(height: 4.h),
                if (subTitle != null)
                  CustomText.titleSmall(
                    subTitle!,
                    textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: context.colors.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
              ],
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}
