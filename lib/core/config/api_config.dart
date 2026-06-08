// Path: lib/core/config/api_config.dart

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:5166',
  );

  // Common
  static const String userMe = '$baseUrl/api/common/users/me';

  // Habits
  static const String habits = '$baseUrl/api/habits';
}