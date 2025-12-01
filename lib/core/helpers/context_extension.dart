import 'package:charity_app/core/config/res/constants_manager.dart';
import 'package:charity_app/core/config/res/refactor_color_manager.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  double get width => mediaQuery.size.width;

  double get height => mediaQuery.size.height;

  bool get isKeyboardOpen =>
      MediaQuery.of(this).viewInsets.bottom > ConstantManager.zero;

  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  bool get isDark => theme.brightness == Brightness.dark;

  bool get isLight => theme.brightness == Brightness.light;

  bool get isMaterial => theme.platform == TargetPlatform.android;

  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

extension LanguageExtension on Widget {
  Widget overRideLocaization({required BuildContext context}) {
    return Localizations.override(context: context, child: this);
  }
}
