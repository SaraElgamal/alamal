import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    super.key,
    required this.textStyle,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
    this.textScaler = const TextScaler.linear(1.0),
  });

  CustomText.headlineLarge(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.headlineLarge,
        );

  CustomText.headlineMedium(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.headlineMedium,
        );

  CustomText.headlineSmall(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.headlineSmall,
        );

  CustomText.titleLarge(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextDirection? textDirection,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textDirection: textDirection,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.titleLarge,
        );

  CustomText.titleMedium(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.titleMedium,
        );

  CustomText.titleSmall(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.titleSmall,
        );

  CustomText.bodySmall(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.bodySmall,
        );

  CustomText.bodyMedium(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.bodyMedium,
        );

  CustomText.bodyLarge(
    String text, {
    Key? key,
    TextAlign? textAlign,
    String? fontFamily,
    int? maxLines,
    TextStyle? textStyle,
    TextOverflow? overflow,
    TextScaler? textScaler,
  }) : this(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
          textScaler: textScaler ?? const TextScaler.linear(1.0),
          textStyle: textStyle ??
              Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.bodyLarge,
        );

  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ?? Theme.of(context).textTheme.titleMedium,
      textAlign: textAlign ?? TextAlign.center,
      textDirection: textDirection,
      overflow: overflow,
      maxLines: maxLines,
      textScaler: textScaler,
    );
  }
}
