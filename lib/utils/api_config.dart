///   - Android emulator  -> 10.0.2.2 (alias localhost milik komputer host)
///   - iOS simulator / web / desktop -> ganti ke http://localhost:3000/api
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  static const Duration timeout = Duration(seconds: 20);
}
