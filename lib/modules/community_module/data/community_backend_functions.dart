import 'community_repository.dart';
import '../models/hero_model.dart';
import '../models/post_model.dart';

final CommunityRepository _communityRepository = CommunityRepositoryImpl();

Future<List<HeroModel>> getHeroesOfWeek() async {
  try {
    return await _communityRepository.fetchHeroesOfWeek();
  } catch (e) {
    return getDefaultHeroes();
  }
}

Future<List<PostModel>> getCommunityPosts() async {
  try {
    return await _communityRepository.fetchCommunityPosts();
  } catch (e) {
    return getDefaultPosts();
  }
}

Future<bool> createPost({
  required String content,
  required bool isAnonymous,
}) async {
  try {
    return await _communityRepository.createPost(
      content: content,
      isAnonymous: isAnonymous,
    );
  } catch (e) {
    return false;
  }
}

Future<bool> likePost(String postId) async {
  try {
    return await _communityRepository.likePost(postId);
  } catch (e) {
    return false;
  }
}

Future<bool> commentOnPost({
  required String postId,
  required String comment,
}) async {
  try {
    return await _communityRepository.commentOnPost(
      postId: postId,
      comment: comment,
    );
  } catch (e) {
    return false;
  }
}

List<HeroModel> getDefaultHeroes() {
  return [
    HeroModel(name: 'Maria', days: 42, imageUrl: 'assets/images/maria.jpg'),
    HeroModel(name: 'David', days: 85, imageUrl: 'assets/images/david.jpg'),
    HeroModel(name: 'Sophie', days: 61, imageUrl: 'assets/images/sophie.jpg'),
    HeroModel(name: 'Chen', days: 76, imageUrl: 'assets/images/chen.jpg'),
  ];
}

List<PostModel> getDefaultPosts() {
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
