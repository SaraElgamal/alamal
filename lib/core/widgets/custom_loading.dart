import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/loading_manager.dart';

class CustomLoading {
  static showLoadingView(context) {
    return Center(
      child: SpinKitDoubleBounce(
        color: context.colors.primary,
        size: AppSize.sH40,
      ),
    );
  }

  static showDotLoader({double? size}) {
    return Container(
      height: size,
      alignment: Alignment.center,
      child: Center(
        child: SpinKitFadingCircle(
          color: NavigationService.currentContext!.colors.primary,
          size: AppSize.sH50,
        ),
      ),
    );
  }

  static showFullScreenLoading() {
    FullScreenLoadingManager.show();
  }

  static hideFullScreenLoading() {
    return FullScreenLoadingManager.hide();
  }
}
