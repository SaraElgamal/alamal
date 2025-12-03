import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset('assets/animation/notfound.json', height: 200, width: 200),
        SizedBox(height: AppSize.sH18),
        CustomText(
          title,
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: context.colors.black.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
