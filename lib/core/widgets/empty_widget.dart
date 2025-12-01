import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.inbox, size: 80, color: context.colors.disabled),
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
