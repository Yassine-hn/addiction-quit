import 'community_repository.dart';
import '../models/hero_model.dart';
import '../models/post_model.dart';

final CommunityRepository _communityRepository = CommunityRepositoryImpl();

Future<List<HeroModel>> getHeroesOfWeek() async {
  try {
    return await _communityRepository.fetchHeroesOfWeek();
  } catch (e) {
    print('Error getting heroes: $e');
    return getDefaultHeroes();
  }
}

Future<List<PostModel>> getCommunityPosts() async {
  try {
    return await _communityRepository.fetchCommunityPosts();
  } catch (e) {
    print('Error getting posts: $e');
    return getDefaultPosts();
  }
}

Future<bool> createPost({
  required String content,
}) async {
  try {
    return await _communityRepository.createPost(
      content: content,
    );
  } catch (e) {
    print('Error creating post: $e');
    return false;
  }
}

Future<bool> likePost(int postId) async {
  try {
    return await _communityRepository.likePost(postId);
  } catch (e) {
    print('Error liking post: $e');
    return false;
  }
}

Future<bool> commentOnPost({
  required int postId,
  required String comment,
}) async {
  try {
    return await _communityRepository.commentOnPost(
      postId: postId,
      comment: comment,
    );
  } catch (e) {
    print('Error commenting on post: $e');
    return false;
  }
}

List<HeroModel> getDefaultHeroes() {
  return [
    HeroModel(name: 'Maria', days: 42, imageUrl: 'assets/images/default_avatar.png'),
    HeroModel(name: 'David', days: 85, imageUrl: 'assets/images/default_avatar.png'),
    HeroModel(name: 'Sophie', days: 61, imageUrl: 'assets/images/default_avatar.png'),
    HeroModel(name: 'Chen', days: 76, imageUrl: 'assets/images/default_avatar.png'),
  ];
}

List<PostModel> getDefaultPosts() {
  return [
    PostModel(
      authorName: 'Welcome',
      authorImage: 'assets/images/default_avatar.png',
      timeAgo: 'Just now',
      content:
          'Welcome to the community! Share your journey and support others in their recovery.',
      likes: 0,
      comments: 0,
      badge: null,
    ),
  ];
}
