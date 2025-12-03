import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/core/widgets/custom_loading.dart';
import 'custom_animated_button.dart';

class LoadingButton extends StatelessWidget {
  final String title;
  final Future<void> Function() onTap;
  final Color? textColor;
  final Color? color;
  final BorderSide borderSide;
  final double? borderRadius;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Widget? customChild;

  const LoadingButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.textColor,
    this.borderRadius,
    this.margin,
    this.borderSide = BorderSide.none,
    this.fontFamily,
    this.fontSize,
    this.width,
    this.height,
    this.fontWeight,
    this.customChild,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          margin ??
          EdgeInsets.symmetric(
            horizontal: AppMargin.mW10,
            vertical: AppMargin.mH10,
          ),
      child: CustomAnimatedButton(
        onTap: onTap,
        width: width ?? MediaQuery.sizeOf(context).width,
        minWidth: AppSize.sW50,
        height: height ?? AppSize.sH50,
        color: color ?? context.colors.primary,
        borderRadius: borderRadius ?? AppSize.sH10,
        disabledColor: color ?? context.colors.primary5,
        borderSide: borderSide,
        loader: CustomLoading.showDotLoader(
          color: context.colors.white,
          size: AppSize.sH50,
        ),
        child:
            customChild ??
            Text(
              title,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: fontWeight ?? FontWeight.w500,
                fontSize: fontSize ?? FontSize.s16,
              ),
            ),
      ),
    );
  }
}
