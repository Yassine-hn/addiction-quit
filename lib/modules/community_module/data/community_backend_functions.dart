import 'community_repository.dart';
import '../models/hero_model.dart';
import '../models/post_model.dart';

final CommunityRepository _communityRepository = CommunityRepositoryImpl();

Future<({List<HeroModel> data, String? error})> getHeroesOfWeek() async {
  try {
    final data = await _communityRepository.fetchHeroesOfLastMonth();
    return (data: data, error: null);
  } catch (e) {
    print('Error getting heroes: $e');
    return (data: <HeroModel>[], error: 'Failed to load heroes. Please check your connection.');
  }
}

Future<({List<PostModel> data, String? error})> getCommunityPosts({int limit = 20, int offset = 0}) async {
  try {
    final data = await _communityRepository.fetchCommunityPosts(limit: limit, offset: offset);
    return (data: data, error: null);
  } catch (e) {
    print('Error getting posts: $e');
    return (data: <PostModel>[], error: 'Failed to load posts. Please check your connection.');
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

Future<bool> deletePost(int postId) async {
  try {
    return await _communityRepository.deletePost(postId);
  } catch (e) {
    print('Error deleting post: $e');
    return false;
  }
}

Future<bool> deleteComment(int commentId) async {
  try {
    return await _communityRepository.deleteComment(commentId);
  } catch (e) {
    print('Error deleting comment: $e');
    return false;
  }
}
