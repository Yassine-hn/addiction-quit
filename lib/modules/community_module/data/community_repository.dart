import '../models/hero_model.dart';
import '../models/post_model.dart';

abstract class CommunityRepository {
  Future<List<HeroModel>> fetchHeroesOfWeek();
  Future<List<PostModel>> fetchCommunityPosts();
  Future<bool> createPost({required String content, required bool isAnonymous});
  Future<bool> likePost(String postId);
  Future<bool> commentOnPost({required String postId, required String comment});
  Future<bool> deletePost(String postId);
  Future<bool> reportPost(String postId, String reason);
}

class CommunityRepositoryImpl implements CommunityRepository {
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<HeroModel>> fetchHeroesOfWeek() async {
    await _simulateDelay();
    return [
      HeroModel(name: 'Maria', days: 42, imageUrl: 'assets/images/maria.jpg'),
      HeroModel(name: 'David', days: 85, imageUrl: 'assets/images/david.jpg'),
      HeroModel(name: 'Sophie', days: 61, imageUrl: 'assets/images/sophie.jpg'),
      HeroModel(name: 'Chen', days: 76, imageUrl: 'assets/images/chen.jpg'),
    ];
  }

  @override
  Future<List<PostModel>> fetchCommunityPosts() async {
    await _simulateDelay();
    return [
      PostModel(
        authorName: 'Dr. Emily Carter',
        authorImage: 'assets/images/emily.jpg',
        timeAgo: '2 hours ago',
        content:
            'Remember that recovery is a journey, not a destination. Each step, no matter how small, is a victory. Be kind to yourself today. #Motivation #ExpertAdvice',
        likes: 125,
        comments: 18,
        badge: 'Expert',
      ),
      PostModel(
        authorName: 'John S.',
        authorImage: 'assets/images/john.jpg',
        timeAgo: '7 hours ago',
        content:
            'Just hit my 30-day milestone. It\'s been tough, but this community has been a huge help. Thank you all for the support. We can do this!',
        likes: 247,
        comments: 42,
        badge: null,
      ),
      PostModel(
        authorName: 'Sarah K.',
        authorImage: 'assets/images/sarah.jpg',
        timeAgo: '1 day ago',
        content:
            'Feeling a bit down today, but reading everyone\'s stories is really inspiring. Does anyone have tips for dealing with cravings in social situations?',
        likes: 98,
        comments: 27,
        badge: null,
      ),
    ];
  }

  @override
  Future<bool> createPost({
    required String content,
    required bool isAnonymous,
  }) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> likePost(String postId) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> commentOnPost({
    required String postId,
    required String comment,
  }) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> deletePost(String postId) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> reportPost(String postId, String reason) async {
    await _simulateDelay();
    return true;
  }
}
