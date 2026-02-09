/// Theme type enumeration for the application.
enum AppThemeType {
  current,
  orange,
  green;

  /// Convert theme type to string for persistence.
  String toValue() {
    switch (this) {
      case AppThemeType.current:
        return 'current';
      case AppThemeType.orange:
        return 'orange';
      case AppThemeType.green:
        return 'green';
    }
  }

  /// Create theme type from string value.
  static AppThemeType fromValue(String value) {
    switch (value) {
      case 'orange':
        return AppThemeType.orange;
      case 'green':
        return AppThemeType.green;
      case 'current':
      default:
        return AppThemeType.current;
    }
  }

  /// Get display name for the theme.
  String get displayName {
    switch (this) {
      case AppThemeType.current:
        return 'Current';
      case AppThemeType.orange:
        return 'Orange';
      case AppThemeType.green:
        return 'Green';
    }
  }
}
