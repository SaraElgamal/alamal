import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/buttons/default_button.dart';
import 'package:charity_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.buttonText,
    this.onPressed,
    required this.hasButton,
    this.maxLines = 3,
  });

  final String title;
  final String subTitle;
  final Widget icon;
  final String? buttonText;
  final bool hasButton;
  final void Function()? onPressed;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              icon,
              // AppSize.sH25.sw,
              CustomText(
                title,
                textStyle: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeightManager.medium,
                  color: context.colors.black.withValues(alpha: 0.8),
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.fontFamily,
                ),
              ),
              // AppSize.sH25.szH,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  subTitle,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textStyle: TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeightManager.regular,
                    color: context.colors.black.withValues(alpha: 0.8),
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          // const Expanded(child: SizedBox()),
          //   if (hasButton) AppSize.sH25.szH,
          if (hasButton)
            DefaultButton(
              width: MediaQuery.of(context).size.width * .90,
              title: buttonText ?? 'Click!',
              textColor: context.colors.white,
              fontSize: FontSize.s12,
              fontWeight: FontWeight.w500,
              onTap: onPressed,
            ),
          //AppSize.sH30.szH,
        ],
      ),
    );
  }
}
