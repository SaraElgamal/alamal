import 'package:flutter/material.dart';
import 'package:charity_app/core/helpers/context_extension.dart';

class ButtonLoadingWidget extends StatelessWidget {
  const ButtonLoadingWidget({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Center(
        child: CircularProgressIndicator(
          color: color ?? context.colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
