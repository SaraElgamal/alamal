import 'package:flutter/material.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: onRefresh,
    );
  }
}
