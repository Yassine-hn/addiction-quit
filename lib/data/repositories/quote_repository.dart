// quote_repository.dart
import 'quote_repository_abstract.dart';

/// Implementation of QuoteRepository
/// For now, this uses a predefined list of quotes.
/// In the future, this can be extended to fetch from a database or API
class QuoteRepositoryImpl implements QuoteRepository {
  static const List<Map<String, String>> _quotes = [
    {
      'text':
          'The greatest glory in living lies not in never falling, but in rising every time we fall.',
      'author': 'Nelson Mandela',
    },
    {
      'text': 'You are stronger than your struggles and wiser than your worries.',
      'author': 'Unknown',
    },
    {
      'text': 'Every day is a fresh start. Each sunrise is a new chapter in your story waiting to be written.',
      'author': 'Unknown',
    },
    {
      'text': 'Progress, not perfection. Every step forward counts.',
      'author': 'Unknown',
    },
    {
      'text': 'The only way out is through. Keep going, one day at a time.',
      'author': 'Unknown',
    },
    {
      'text': 'You didn\'t come this far to only come this far. Keep pushing forward.',
      'author': 'Unknown',
    },
    {
      'text': 'Recovery is not a race. You don\'t have to feel guilty if it takes you longer than you thought it would.',
      'author': 'Unknown',
    },
    {
      'text': 'Your past doesn\'t define you. Your present does. Make it count.',
      'author': 'Unknown',
    },
    {
      'text': 'Small steps everyday lead to big changes over time.',
      'author': 'Unknown',
    },
    {
      'text': 'The best time to start was yesterday. The second best time is now.',
      'author': 'Unknown',
    },
  ];

  /// Get a daily quote based on the current date
  /// This ensures the same quote is shown throughout the day
  @override
  Future<Map<String, String>> getDailyQuote() async {
    // Use the day of year to select a quote deterministically
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final quoteIndex = dayOfYear % _quotes.length;
    
    return _quotes[quoteIndex];
  }

  /// Get a random quote (alternative method)
  Future<Map<String, String>> getRandomQuote() async {
    final random = DateTime.now().millisecondsSinceEpoch;
    final quoteIndex = random % _quotes.length;
    return _quotes[quoteIndex];
  }
}

