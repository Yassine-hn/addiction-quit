// quote_repository_abstract.dart

/// Repository for daily quotes
abstract class QuoteRepository {
  Future<Map<String, String>> getDailyQuote();
}

