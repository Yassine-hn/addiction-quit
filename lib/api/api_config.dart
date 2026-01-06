/// API Configuration for different environments
class ApiConfig {
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// Production API URL (Render.com deployment)
  /// Update this after deploying to Render
  static const String productionUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://YOUR-SERVICE-NAME.onrender.com',
  );

  /// Development API URLs
  static const String developmentUrlAndroid = 'http://10.0.2.2:5000';
  static const String developmentUrlIOS = 'http://localhost:5000';
  static const String developmentUrlWeb = 'http://localhost:5000';

  /// Get the appropriate base URL based on environment and platform
  static String getBaseUrl() {
    if (environment == 'production') {
      return productionUrl;
    }

    // Development mode - platform-specific
    // This is a simple heuristic; you can use dart:io Platform for better detection
    return developmentUrlAndroid; // Default to Android emulator
  }

  /// Health check endpoint
  static String get healthCheckUrl => '${getBaseUrl()}/health';

  /// API version
  static const String apiVersion = 'v1';
}
