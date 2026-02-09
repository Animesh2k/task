import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme_type.dart';

/// Service for managing theme persistence.
class ThemeService {
  static const String _themeKey = 'app_theme';

  /// Get the saved theme preference.
  /// Returns [AppThemeType.current] if no preference exists.
  Future<AppThemeType> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeValue = prefs.getString(_themeKey);
    
    if (themeValue == null) {
      return AppThemeType.current;
    }
    
    return AppThemeType.fromValue(themeValue);
  }

  /// Save the theme preference.
  Future<void> setTheme(AppThemeType theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.toValue());
  }
}
