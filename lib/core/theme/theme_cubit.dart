import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeCubit extends Cubit<AppThemeMode> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences prefs;

  ThemeCubit(this.prefs) : super(AppThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      emit(AppThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => AppThemeMode.system,
      ));
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    await prefs.setString(_themeKey, mode.toString());
    emit(mode);
  }

  Future<void> toggleTheme() async {
    final newMode = state == AppThemeMode.light
        ? AppThemeMode.dark
        : state == AppThemeMode.dark
            ? AppThemeMode.light
            : AppThemeMode.light;
    await setTheme(newMode);
  }
}
