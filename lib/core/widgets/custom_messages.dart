import 'dart:async';

import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/config/res/color_manager.dart';
import 'package:charity_app/core/config/res/constants_manager.dart';
import 'package:charity_app/core/helpers/context_extension.dart';


class MessageUtils {
  static OverlayEntry? _currentOverlay;

  static void showNotification({
    required String title,
    required String body,
    VoidCallback? onTap,
  }) {
    _showTopNotice(
      title, // Using title as the main message for now, or we can combine
      body: body,
      context: NavigationService.navigatorKey.currentContext,
      backgroundColor: NavigationService.currentContext!.colors.cardPrimary,
      foregroundColor: Colors.white,
      iconData: Icons.notifications_active,
      onTap: onTap,
    );
  }

  static void showSuccess(String message, {BuildContext? context}) {
    _showTopNotice(
      message,
      context: context,
      backgroundColor: NavigationService.currentContext!.colors.successECFDF3,
      foregroundColor: NavigationService.currentContext!.colors.success60,
      iconData: Icons.check,
    );
  }

  static void showError(String message, {BuildContext? context}) {
    _showTopNotice(
      message,
      context: context,
      backgroundColor: NavigationService.currentContext!.colors.toastBackGroundError,
      foregroundColor: NavigationService.currentContext!.colors.toastError,
      iconData: Icons.priority_high_rounded,
    );
  }

  static void _showTopNotice(
    String message, {
    String? body,
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData iconData,
    BuildContext? context,
    VoidCallback? onTap,
  }) {
    final targetContext = context ?? NavigationService.navigatorKey.currentContext;
    if (targetContext == null) return;

    final overlayState = Overlay.maybeOf(targetContext, rootOverlay: true) ??
        NavigationService.navigatorKey.currentState?.overlay;
    if (overlayState == null) {
      showSnackBar(
        message,
        backgroundColor: backgroundColor,
        textColor: foregroundColor,
        context: targetContext,
      );
      return;
    }

    _currentOverlay?.remove();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TopNoticeOverlay(
        message: message,
        body: body,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        iconData: iconData,
        onTap: onTap,
        onDismissed: () {
          if (_currentOverlay == entry) {
            _currentOverlay = null;
          }
          entry.remove();
        },
      ),
    );

    _currentOverlay = entry;
    overlayState.insert(entry);
  }

  static void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    BuildContext? context,
  }) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: ConstantManager.snackbarDuration),
      content: Text(
        message,
        style: TextStyle(
          color: textColor ?? NavigationService.currentContext!.colors.error,
          fontSize: FontSize.s14,
          fontWeight: FontWeight.w600,
          fontFamily: ConstantManager.fontFamily,
        ),
      ),
      backgroundColor: backgroundColor ?? NavigationService.currentContext!.colors.white,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: textColor ?? NavigationService.currentContext!.colors.error,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.bR4),
      ),
    );
    ScaffoldMessenger.of(context ?? NavigationService.navigatorKey.currentContext!)
        .showSnackBar(snackBar);
  }

  static void showSimpleToast({
    required String msg,
    Color? color,
    Color? textColor,
    ToastGravity? gravity,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      textColor: textColor ?? Colors.white,
      fontSize: 16.sp,
      backgroundColor: color ?? Colors.black,
    );
  }

  static void showErrorToast({
    required String msg,
    ToastGravity? gravity,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      textColor: AppColors.error,
      fontSize: 16.sp,
      backgroundColor: NavigationService.navigatorKey.currentContext!.colors.error,
    );
  }

  static void showSuccessToast({
    required String msg,
    ToastGravity? gravity,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      textColor: AppColors.success60,
      fontSize: 16.sp,
      backgroundColor: NavigationService.navigatorKey.currentContext!.colors.success,
    );
  }
}

class _TopNoticeOverlay extends StatefulWidget {
  const _TopNoticeOverlay({
    required this.message,
    this.body,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconData,
    required this.onDismissed,
    this.onTap,
  });

  final String message;
  final String? body;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData iconData;
  final VoidCallback onDismissed;
  final VoidCallback? onTap;

  @override
  State<_TopNoticeOverlay> createState() => _TopNoticeOverlayState();
}

class _TopNoticeOverlayState extends State<_TopNoticeOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _controller.forward();

    _hideTimer = Timer(
      const Duration(seconds: ConstantManager.snackbarDuration),
      _hide,
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _hide() {
    if (!mounted) return;
    if (!_controller.isAnimating && !_controller.isCompleted) return;
    _controller.reverse().whenComplete(() {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false, // Allow interactions
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final offset = Tween<Offset>(
                begin: const Offset(0, -0.3),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ));

              final opacity = CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              );

              return FractionalTranslation(
                translation: offset.value,
                child: Opacity(
                  opacity: opacity.value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: GestureDetector(
                      onTap: () {
                        widget.onTap?.call();
                        _hide();
                      },
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(AppRadius.bR12),
                        color: widget.backgroundColor,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.bR12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 28.sp,
                                width: 28.sp,
                                decoration: BoxDecoration(
                                  color: widget.foregroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.iconData,
                                  color: widget.backgroundColor,
                                  size: 16.sp,
                                ),
                              ),
                             // AppSize.sW12.szW,
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.message,
                                      style: TextStyle(
                                        color: widget.foregroundColor,
                                        fontSize: FontSize.s14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantManager.fontFamily,
                                      ),
                                    ),
                                    if (widget.body != null) ...[
                                    //   AppSize.sH4.szH,
                                      Text(
                                        widget.body!,
                                        style: TextStyle(
                                          color: widget.foregroundColor.withOpacity(0.9),
                                          fontSize: FontSize.s12,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: ConstantManager.fontFamily,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
