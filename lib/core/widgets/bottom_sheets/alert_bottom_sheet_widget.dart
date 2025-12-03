import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/config/res/assets.gen.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/buttons/default_button.dart';
import 'package:charity_app/core/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertBottomSheetWidget extends StatelessWidget {
  const AlertBottomSheetWidget({
    super.key,
    this.icon,
    this.confirmText,
    this.backText,
    this.onConfirm,
    this.onBack,
    this.enableBack = true,
    this.body,
    this.backGroundColor,
    this.customChild,
    this.confirmTextColor,
    this.isLoading = false,
    this.sheetBgColor,
  });

  final SvgGenImage? icon;
  final String? confirmText;
  final String? backText;
  final Widget? body;
  final Widget? customChild;
  final VoidCallback? onConfirm, onBack;
  final Color? backGroundColor, confirmTextColor, sheetBgColor;
  final bool enableBack;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: sheetBgColor ?? context.colors.background,
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
          Container(
            height: 7.h,
            width: 130.w,
            margin: EdgeInsets.only(top: 20.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: context.colors.black10,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          SizedBox(height: 28.h),
          if (icon != null) icon!.svg(),
          if (icon != null) SizedBox(height: 24.h),
          // if (body != null) body!,
          Flexible(
            child: SingleChildScrollView(
              child: Column(children: [if (body != null) body!]),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              if (onConfirm != null)
                Expanded(
                  child: DefaultButton(
                    onTap: onConfirm!,
                    title: confirmText ?? '',
                    margin: EdgeInsets.zero,
                    color: backGroundColor,
                    textColor: confirmTextColor,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeightManager.regular,
                    customChild:
                        customChild ??
                        ((isLoading)
                            ? SizedBox(
                                width: 25,
                                height: 25,
                                child: Center(
                                  child: CustomLoading.showDotLoader(
                                    color: context.colors.white,
                                    size: 25,
                                  ),
                                ),
                              )
                            : null),
                  ),
                ),
              if (enableBack) SizedBox(width: 20.w),
              if (enableBack)
                Expanded(
                  child: DefaultButton(
                    onTap: onBack ?? () => Navigator.pop(context),
                    title: backText ?? '',
                    color: context.colors.whiteF4F5F6,
                    borderColor: context.colors.transparent,
                    textColor: context.colors.cancelButtonInSavedAddresses,
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.fontFamily,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeightManager.regular,
                    margin: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

// Helpers.showBottomSheet(
// context,
// bottomSheet: AlertBottomSheetWidget(
// icon: 'logout-img.svg'.addIconAsset(),
// title: '${'logout'.tr()} !',
// subTitle: 'areYouSure'.tr(),
// confirmText: 'yes'.tr(),
// onConfirm: () {},
// ),
// );
