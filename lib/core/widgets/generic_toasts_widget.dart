import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/core/config/res/color_manager.dart';
import 'package:charity_app/core/helpers/context_extension.dart';

enum BannerType { success, error, warning }

class NotificationBanner extends StatelessWidget {
  final BannerType type;
  final String message;
  final EdgeInsets? margin;

  const NotificationBanner({Key? key, required this.type, required this.message, this.margin})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Color backgroundColor;
    late final Color foregroundColor;
    late final IconData iconData;

    switch (type) {
      case BannerType.success:
        backgroundColor = AppColors.successECFDF3;
        foregroundColor = AppColors.success60;
        iconData = Icons.priority_high_rounded;
        break;
      case BannerType.error:
        backgroundColor = NavigationService.currentContext!.colors.toastBackGroundError;
        foregroundColor = NavigationService.currentContext!.colors.toastError;
        iconData = Icons.priority_high_rounded;
        break;
      case BannerType.warning:
        backgroundColor = AppColors.secondary.withAlpha(10);
        foregroundColor = AppColors.secondary;
        iconData = Icons.priority_high_rounded;
        break;
    }
    return Container(
      margin: margin ?? EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8.0, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(color: foregroundColor, shape: BoxShape.circle),
            child: Icon(iconData, color: Colors.white, size: 16.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(color: foregroundColor, fontSize: 14.0, fontWeight: FontWeight.w600),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
