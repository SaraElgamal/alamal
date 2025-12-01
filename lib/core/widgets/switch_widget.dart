import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const SwitchWidget({super.key, required this.initialValue, required this.onChanged});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant SwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      isOn = widget.initialValue;
    }
  }

  void _toggleSwitch(bool value) {
    setState(() => isOn = value);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isOn,
      onChanged: _toggleSwitch,
      activeTrackColor: context.colors.primary5.withValues(alpha: 0.5),
      activeColor: context.colors.primary5.withValues(alpha: 0.5),
      activeThumbColor: context.colors.primary5.withValues(alpha: 0.5),
      inactiveTrackColor: context.colors.primary5.withValues(alpha: 0.5),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.colors.primary;
        } else {
          return context.colors.white;
        }
      }),
      trackOutlineWidth: WidgetStateProperty.all(16),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.colors.primary5.withValues(alpha: 0.05);
        } else {
          return context.colors.primary5.withValues(alpha: 0.5);
        }
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.colors.primary5.withValues(alpha: 0.5);
        } else {
          return context.colors.black10;
        }
      }),
    );
  }
}
