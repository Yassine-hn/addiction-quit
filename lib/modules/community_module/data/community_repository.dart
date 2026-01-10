import '../models/hero_model.dart';
import '../models/post_model.dart';
import '../../../api/api_service.dart';
import '../../../data/repositories/user_repository.dart';

abstract class CommunityRepository {
  Future<List<HeroModel>> fetchHeroesOfLastMonth();
  Future<List<PostModel>> fetchCommunityPosts({int limit = 20, int offset = 0});
  Future<bool> createPost({required String content});
  Future<bool> likePost(int postId);
  Future<bool> commentOnPost({required int postId, required String comment});
  Future<bool> deletePost(int postId);
  Future<bool> deleteComment(int commentId);
}

class CommunityRepositoryImpl implements CommunityRepository {
  final ApiService _apiService = ApiService();
  final UserRepositoryImpl _userRepo = UserRepositoryImpl();

  @override
  Future<List<HeroModel>> fetchHeroesOfLastMonth() async {
    try {
      final response = await _apiService.getHeroesLastMonth();
      
      if (!response.success) {
        throw Exception(response.message);
      }

      if (response.data == null) {
        return [];
      }

      final List<dynamic> heroesData = response.data is List ? response.data as List : [];
      
      return heroesData.map((hero) {
        return HeroModel.fromMap(hero as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching heroes: $e');
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> fetchCommunityPosts({int limit = 20, int offset = 0}) async {
    try {
      final response = await _apiService.getPublicPosts(limit: limit, offset: offset);
      
      if (!response.success) {
        throw Exception(response.message);
      }

      if (response.data == null) {
        return [];
      }

      final List<dynamic> postsData = response.data is List ? response.data as List : [];
      
      return postsData.map((post) {
        return PostModel.fromMap(post as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      rethrow;
    }
  }

  @override
  Future<bool> createPost({required String content}) async {
    try {
      // Check if user is logged in
      final userId = await _userRepo.getCurrentUserId();
      if (userId == null) {
        print('No user logged in');
        return false;
      }

      final response = await _apiService.createPost(content: content);
      
      if (!response.success) {
        print('Error creating post: ${response.message}');
        return false;
      }

      return true;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  @override
  Future<bool> likePost(int postId) async {
    try {
      // Check if user is logged in
      final userId = await _userRepo.getCurrentUserId();
      if (userId == null) {
        print('No user logged in');
        return false;
      }

      final response = await _apiService.togglePostReaction(postId);
      
      if (!response.success) {
        print('Error liking post: ${response.message}');
        return false;
      }

      return true;
    } catch (e) {
      print('Error liking post: $e');
      return false;
    }
  }

  @override
  Future<bool> commentOnPost({
    required int postId,
    required String comment,
  }) async {
    try {
      // Check if user is logged in
      final userId = await _userRepo.getCurrentUserId();
      if (userId == null) {
        print('No user logged in');
        return false;
      }

      final response = await _apiService.createComment(
        postId: postId,
        content: comment,
      );
      
      if (!response.success) {
        print('Error commenting on post: ${response.message}');
        return false;
      }

      return true;
    } catch (e) {
      print('Error commenting on post: $e');
      return false;
    }
  }

  @override
  Future<bool> deletePost(int postId) async {
    try {
      // Check if user is logged in
      final userId = await _userRepo.getCurrentUserId();
      if (userId == null) {
        print('No user logged in');
        return false;
      }

      final response = await _apiService.deletePost(postId);
      
      if (!response.success) {
        print('Error deleting post: ${response.message}');
        return false;
      }

      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteComment(int commentId) async {
    try {
      // Check if user is logged in
      final userId = await _userRepo.getCurrentUserId();
      if (userId == null) {
        print('No user logged in');
        return false;
      }

      final response = await _apiService.deleteComment(commentId);
      
      if (!response.success) {
        print('Error deleting comment: ${response.message}');
        return false;
      }

      return true;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }
}
