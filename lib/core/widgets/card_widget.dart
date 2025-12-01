import 'package:flutter/material.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.radius,
    this.onClick,
    this.constraints,
    this.borderColor,
    this.isShadow = false,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding, margin;
  final double? height, width, radius;
  final VoidCallback? onClick;
  final Color? borderColor;
  final BoxConstraints? constraints;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(AppRadius.bR16),
      child: Container(
        height: height,
        width: width,
        constraints: constraints,
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colors.whiteBtn,
          borderRadius: BorderRadius.circular(radius ?? 16),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: 1,
          ),
          boxShadow: isShadow
              ? [
                  BoxShadow(
                    color: context.colors.black5,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        padding: padding,
        margin: margin,
        child: Center(child: child),
      ),
    );
  }
}
