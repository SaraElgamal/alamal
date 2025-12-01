import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:lottie/lottie.dart';

class LottieLoadingDialog extends StatelessWidget {
  const LottieLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              width: 500.0.w,
              height: 400.0.h,
              decoration: BoxDecoration(
                color: context.colors.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: context.colors.primary.withAlpha(20),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  width: 350.0.w,
                  height: 300.0.h,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

