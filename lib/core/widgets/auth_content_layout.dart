import 'package:flutter/material.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';

class AuthContentLayout extends StatelessWidget {
  const AuthContentLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: AppSize.sH140),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.bR10),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.zero,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: AppPadding.pH18,
          ),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.bR10),
              topRight: Radius.circular(AppRadius.bR10),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
