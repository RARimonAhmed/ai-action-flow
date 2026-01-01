class ApiConstants {
  // Base URL - Replace with your actual API
  static const String baseUrl = 'https://api.openai.com/v1';

  // Endpoints
  static const String chatCompletions = '/chat/completions';

  // API Keys (should be moved to environment variables in production)
  static const String apiKeyHeader = 'Authorization';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Model
  static const String defaultModel = 'gpt-3.5-turbo';

  // Token limits
  static const int maxTokens = 1000;
}