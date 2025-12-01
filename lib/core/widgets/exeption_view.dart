import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'buttons/default_button.dart';

class ExceptionView extends StatelessWidget {
  const ExceptionView({super.key, this.onTap, this.errorText});

  final VoidCallback? onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // AppAssets.lottie.error.lottie(
        //   width: MediaQuery.of(context).size.width * .7,
        //   height: MediaQuery.of(context).size.height * .3,
        // ),
        Icon(Icons.error_outline_sharp, color: context.colors.error, size: 150.sp),
        Container(
          margin: EdgeInsets.symmetric(vertical: AppMargin.mH20),
          child: Center(
            child: Text(
              errorText ?? 'Exception Error',
              style: TextStyle(
                fontSize: FontSize.s18,
                color: context.colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DefaultButton(
          width: MediaQuery.of(context).size.width * .45,
          title: 'Retry',
          textColor: context.colors.white,
          fontSize: FontSize.s14,
          fontWeight: FontWeight.w500,
          onTap: onTap,
        ),
      ],
    );
  }
}
