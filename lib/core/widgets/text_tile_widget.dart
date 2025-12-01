import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/widgets/custom_text.dart';

class TextTileWidget extends StatelessWidget {
  const TextTileWidget({
    super.key,
    required this.title,
    this.value,
    this.titleColor,
    this.valueColor,
    this.valueWidget,
  });

  final String title;
  final String? value;
  final Color? titleColor, valueColor;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(
          child: CustomText.titleLarge(
            title,
            textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeightManager.semiBold,
              color: titleColor ?? context.colors.black.withValues(alpha: 0.7),
            ),
          ),
        ),
      //  AppSize.sW20.szW,
        (valueWidget == null)
            ? Flexible(
                child: CustomText.titleLarge(
                  value ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // textDirection: LanguageManager.currentLang == 'ar'
                  //     ? TextDirection.ltr
                  //     : TextDirection.rtl,
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeightManager.semiBold,
                    color: valueColor ?? context.colors.black.withValues(alpha: 0.8),
                  ),
                ),
              )
            : valueWidget!,
      ],
    );
  }
}
