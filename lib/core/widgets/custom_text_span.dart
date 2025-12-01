import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';

class CustomTextSpan extends StatelessWidget {
  const CustomTextSpan({
    super.key,
    this.title,
    this.children,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.titleStyle,
    this.titleRecognizer,
    this.textAlign,
  });

  final String? title;
  final List<InlineSpan>? children;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextStyle? titleStyle;
  final GestureRecognizer? titleRecognizer;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        text: title ?? '',
        recognizer: titleRecognizer,
        style:
            titleStyle ??
            TextStyle(
              fontSize: fontSize ?? FontSize.s14,
              fontWeight: fontWeight ?? FontWeightManager.semiBold,
              color: color ?? context.colors.black.withValues(alpha: 0.7),
              fontFamily: fontFamily ?? Theme.of(context).textTheme.bodyMedium?.fontFamily,
            ),
        children: children ?? [],
      ),
    );
  }
}
