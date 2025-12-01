import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransitions {
  static CustomTransitionPage<void> slideFromRight({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
      final double beginX = isRtl ? -1.0 : 1.0;
        final begin = Offset(beginX, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
