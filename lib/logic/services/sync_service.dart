import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_service.dart';
import '../../data/storage/token_storage.dart';
import '../../data/repositories/posts_repository.dart';
import '../../data/repositories/comments_repository.dart';
import '../../data/repositories/post_reactions_repository.dart';
import '../../data/repositories/heroes_repository.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

class SyncService {
  final ApiService _apiService;
  final PostsRepository _postsRepo = PostsRepository();
  final CommentsRepository _commentsRepo = CommentsRepository();
  final PostReactionsRepository _reactionsRepo = PostReactionsRepository();
  final HeroesRepository _heroesRepo = HeroesRepository();
  final NotificationsRepository _notificationsRepo = NotificationsRepository();

  static const String _lastSyncTimeKey = 'last_sync_time';
  static const String _syncInProgressKey = 'sync_in_progress';

  SyncService(this._apiService);

  /// Check if user is authenticated
  Future<bool> _isAuthenticated() async {
    return await TokenStorage.isLoggedIn();
  }

  /// Get last sync time
  Future<String> _getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSyncTimeKey) ??
        DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
  }

  /// Update last sync time
  Future<void> _updateLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncTimeKey, DateTime.now().toIso8601String());
  }

  /// Check if sync is in progress
  Future<bool> _isSyncInProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_syncInProgressKey) ?? false;
  }

  /// Set sync in progress flag
  Future<void> _setSyncInProgress(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_syncInProgressKey, value);
  }

  /// Full sync strategy: sync all data types
  Future<void> syncAll() async {
    // Only sync if user is authenticated
    if (!await _isAuthenticated()) {
      print('User not authenticated. Skipping sync.');
      return;
    }

    // Prevent duplicate sync
    if (await _isSyncInProgress()) {
      print('Sync already in progress. Skipping.');
      return;
    }

    await _setSyncInProgress(true);

    try {
      final lastSyncTime = await _getLastSyncTime();
      print('Starting sync from: $lastSyncTime');

      // Sync in order: users → posts → comments → reactions → heroes → notifications
      await syncPosts(lastSyncTime);
      await syncComments(lastSyncTime);
      await syncReactions(lastSyncTime);
      await syncHeroes(lastSyncTime);
      await syncNotifications(lastSyncTime);

      await _updateLastSyncTime();
      print('Sync completed successfully');
    } catch (e) {
      print('Error during sync: $e');
    } finally {
      await _setSyncInProgress(false);
    }
  }

  /// Sync posts: download from cloud and upload local changes
  Future<void> syncPosts(String lastSyncTime) async {
    try {
      print('Syncing posts...');

      // 1. Upload local posts created after last sync
      final localPosts = await _postsRepo.getPostsForSync(lastSyncTime);
      for (final post in localPosts) {
        await _uploadPost(post);
      }

      // 2. Download posts from cloud
      final response = await _apiService.getPostsSince(lastSyncTime);
      if (response.success && response.data != null) {
        final posts = response.data as List;
        for (final postData in posts) {
          await _saveSyncedPost(postData);
        }
      }

      print('Posts synced: ${localPosts.length} uploaded, ${response.data?.length ?? 0} downloaded');
    } catch (e) {
      print('Error syncing posts: $e');
    }
  }

  /// Sync comments: download from cloud and upload local changes
  Future<void> syncComments(String lastSyncTime) async {
    try {
      print('Syncing comments...');

      // 1. Upload local comments created after last sync
      final localComments = await _commentsRepo.getCommentsForSync(lastSyncTime);
      for (final comment in localComments) {
        await _uploadComment(comment);
      }

      // 2. Download comments from cloud
      final response = await _apiService.getCommentsSince(lastSyncTime);
      if (response.success && response.data != null) {
        final comments = response.data as List;
        for (final commentData in comments) {
          await _saveSyncedComment(commentData);
        }
      }

      print('Comments synced: ${localComments.length} uploaded');
    } catch (e) {
      print('Error syncing comments: $e');
    }
  }

  /// Sync reactions: download from cloud and upload local changes
  Future<void> syncReactions(String lastSyncTime) async {
    try {
      print('Syncing reactions...');

      // 1. Upload local reactions created after last sync
      final localReactions = await _reactionsRepo.getReactionsForSync(lastSyncTime);
      for (final reaction in localReactions) {
        await _uploadReaction(reaction);
      }

      // 2. Download reactions from cloud
      final response = await _apiService.getReactionsSince(lastSyncTime);
      if (response.success && response.data != null) {
        final reactions = response.data as List;
        for (final reactionData in reactions) {
          await _saveSyncedReaction(reactionData);
        }
      }

      print('Reactions synced: ${localReactions.length} uploaded');
    } catch (e) {
      print('Error syncing reactions: $e');
    }
  }

  /// Sync heroes/leaderboard: download from cloud only (read-only)
  Future<void> syncHeroes(String lastSyncTime) async {
    try {
      print('Syncing heroes...');

      final response = await _apiService.getHeroesSince(lastSyncTime);
      if (response.success && response.data != null) {
        final heroes = response.data as List;
        for (final heroData in heroes) {
          await _saveSyncedHero(heroData);
        }
      }

      print('Heroes synced: ${response.data?.length ?? 0} downloaded');
    } catch (e) {
      print('Error syncing heroes: $e');
    }
  }

  /// Sync notifications: download from cloud only (read-only)
  Future<void> syncNotifications(String lastSyncTime) async {
    try {
      print('Syncing notifications...');

      final response = await _apiService.getNotificationsSince(lastSyncTime);
      if (response.success && response.data != null) {
        final notifications = response.data as List;
        for (final notifData in notifications) {
          await _saveSyncedNotification(notifData);
        }
      }

      print('Notifications synced: ${response.data?.length ?? 0} downloaded');
    } catch (e) {
      print('Error syncing notifications: $e');
    }
  }

  // ============== Upload Local Data ==============

  Future<void> _uploadPost(Map<String, dynamic> post) async {
    try {
      await _apiService.createPost(
        title: post['title'],
        content: post['content'],
        imageUrl: post['image_url'],
        visibility: post['visibility'],
      );
    } catch (e) {
      print('Error uploading post: $e');
    }
  }

  Future<void> _uploadComment(Map<String, dynamic> comment) async {
    try {
      await _apiService.createComment(
        postId: comment['post_id'],
        content: comment['content'],
      );
    } catch (e) {
      print('Error uploading comment: $e');
    }
  }

  Future<void> _uploadReaction(Map<String, dynamic> reaction) async {
    try {
      await _apiService.togglePostReaction(reaction['post_id']);
    } catch (e) {
      print('Error uploading reaction: $e');
    }
  }

  // ============== Save Synced Data ==============

  Future<void> _saveSyncedPost(dynamic postData) async {
    try {
      // Map cloud post data to local post
      final post = {
        'user_id': postData['user_id'],
        'title': postData['title'],
        'content': postData['content'],
        'image_url': postData['image_url'],
        'visibility': postData['visibility'],
        'comment_count': postData['comment_count'] ?? 0,
        'reaction_count': postData['reaction_count'] ?? 0,
        'created_at': postData['created_at'],
      };

      await _postsRepo.createPost(
        userId: post['user_id'],
        title: post['title'],
        content: post['content'],
        imageUrl: post['image_url'],
        visibility: post['visibility'],
      );
    } catch (e) {
      print('Error saving synced post: $e');
    }
  }

  Future<void> _saveSyncedComment(dynamic commentData) async {
    try {
      await _commentsRepo.createComment(
        postId: commentData['post_id'],
        userId: commentData['user_id'],
        content: commentData['content'],
      );
    } catch (e) {
      print('Error saving synced comment: $e');
    }
  }

  Future<void> _saveSyncedReaction(dynamic reactionData) async {
    try {
      // Reactions are synced but we just check if local user reacted
      // No need to save cloud reactions locally for other users
      print('Synced reaction for post ${reactionData['post_id']}');
    } catch (e) {
      print('Error saving synced reaction: $e');
    }
  }

  Future<void> _saveSyncedHero(dynamic heroData) async {
    try {
      await _heroesRepo.updateHeroEntry(
        userId: heroData['user_id'],
        periodType: heroData['period_type'],
        periodStart: DateTime.parse(heroData['period_start']),
        periodEnd: DateTime.parse(heroData['period_end']),
        score: heroData['score'],
        rank: heroData['rank'],
        metricSource: heroData['metric_source'],
        heroBadgeUrl: heroData['hero_badge_url'],
      );
    } catch (e) {
      print('Error saving synced hero: $e');
    }
  }

  Future<void> _saveSyncedNotification(dynamic notifData) async {
    try {
      final userId = await TokenStorage.getUserId();
      if (userId != null) {
        await _notificationsRepo.createNotification(
          userId: int.parse(userId),
          type: notifData['type'],
          data: notifData['data'] ?? '',
        );
      }
    } catch (e) {
      print('Error saving synced notification: $e');
    }
  }
}
