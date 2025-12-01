import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, this.onBackPress});

  final VoidCallback? onBackPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBackPress ?? () => context.pop(),
      child: Container(
        width: AppSize.sW40,
        height: AppSize.sH40,
        margin: EdgeInsetsDirectional.only(start: AppSize.sW16),
        decoration: BoxDecoration(
          color: context.colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.bR10),
        ),
        // child: Center(
        //   child: (context.locale.languageCode == 'ar')
        //       ? AppAssets.svg.arrowRight.svg(
        //           height: AppSize.sH18,
        //           width: AppSize.sW18,
        //         )
        //       : AppAssets.svg.arrowLeft.svg(
        //           height: AppSize.sH18,
        //           width: AppSize.sW18,
        //           colorFilter: const ColorFilter.mode(
        //             context.colors.white,
        //             BlendMode.srcIn,
        //           )),
        // ),
      ),
    );
  }
}
