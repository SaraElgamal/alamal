import 'package:flutter/material.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/custom_loading.dart';

class ButtonLoadingWidget extends StatelessWidget {
  const ButtonLoadingWidget({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Center(
        child: CustomLoading.showDotLoader(
          color: color ?? context.colors.white,
          size: 25,
        ),
      ),
    );
  }
}
