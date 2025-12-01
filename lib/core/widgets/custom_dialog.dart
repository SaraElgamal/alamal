import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/config/res/constants_manager.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';

Future showCustomDialog(BuildContext context,
    {required Widget child,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    bool barrierDismissible = true,
    Color? color}) async {
  showGeneralDialog(
    context: context,
    barrierLabel: ConstantManager.emptyText,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pH20),
          child: Material(
            color: color ?? context.colors.background,
            borderRadius: borderRadius ?? BorderRadius.circular(AppSize.sH25),
            child: Padding(
              padding: padding ?? EdgeInsets.all(AppPadding.pH20),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return ScaleTransition(
        scale: anim,
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
