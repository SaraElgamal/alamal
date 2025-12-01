import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/material.dart';


class ButtonClose extends StatelessWidget {
  final VoidCallback? onTap;

  const ButtonClose({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => NavigationService.pop(),
      child: Container(
        height: AppSize.sH25,
        width: AppSize.sW25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppCircular.r20),
        ),
        child: Center(
          child: Icon(
            Icons.close,
            color: context.colors.text,
            size: AppSize.sH25,
          ),
        ),
      ),
    );
  }
}
