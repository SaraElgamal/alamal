
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/config/res/constants_manager.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final double? width;
  final double? fontSize;
  final double? height;
  final double? elevation;
  final bool? disabled;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Widget? customChild;
  final bool isFitted;

  const DefaultButton({
    super.key,
    this.title,
    this.onTap,
    this.color,
    this.disabled,
    this.textColor,
    this.borderRadius,
    this.margin,
    this.borderColor,
    this.fontFamily,
    this.fontSize,
    this.width,
    this.height,
    this.fontWeight,
    this.elevation,
    this.customChild,
    this.isFitted = true,
  });

  Widget get _defaultChild => Text(
        title ?? 'Click!',
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? FontSize.s16,
          fontFamily: fontFamily,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          EdgeInsets.symmetric(
            horizontal: AppMargin.mW10,
            vertical: AppMargin.mH4,
          ),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? AppSize.sH52,
        child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              splashFactory: InkRipple.splashFactory,
              surfaceTintColor: color ?? NavigationService.currentContext!.colors.primary,
              foregroundColor: color ?? NavigationService.currentContext!.colors.primary,
              backgroundColor: color ?? NavigationService.currentContext!.colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(AppSize.sH10),
                side: borderColor != null
                    ? BorderSide(
                        color: borderColor ?? NavigationService.currentContext!.colors.primary,
                        width: 1,
                      )
                    : BorderSide.none,
              ),
              elevation: elevation ?? ConstantManager.zeroAsDouble,
            ),
            child: isFitted
                ? FittedBox(child: customChild ?? _defaultChild)
                : customChild ?? _defaultChild),
      ),
    );
  }
}
