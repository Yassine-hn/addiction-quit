import 'package:dio/dio.dart';
import '../data/storage/token_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Base URL is provided at build/run time via --dart-define.
  // Defaults to Android emulator loopback if not provided.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );
  // Examples:
  // - Android Emulator: http://10.0.2.2:5000
  // - iOS Simulator:   http://localhost:5000
  // - Device on LAN:   http://<YOUR_COMPUTER_IP>:5000
  
  late final Dio _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptor for token injection
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to requests if available
          final token = await TokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 unauthorized errors
          if (error.response?.statusCode == 401) {
            // Token expired, could implement refresh logic here
            await TokenStorage.clearAll();
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Auth endpoints
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    String? dob,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (dob != null) 'dob': dob,
        },
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _dio.post('/api/auth/logout');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Addiction endpoints
  Future<ApiResponse<List<dynamic>>> getAddictions() async {
    try {
      final response = await _dio.get('/api/addictions');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> createAddiction(
      Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/addictions', data: data);
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updateAddiction(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put('/api/addictions/$id', data: data);
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<void>> deleteAddiction(int id) async {
    try {
      final response = await _dio.delete('/api/addictions/$id');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> resetAddictionCounter(
      int id) async {
    try {
      final response = await _dio.post('/api/addictions/$id/reset');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Survey endpoints
  Future<ApiResponse<List<dynamic>>> getSurveys({
    required int addictionId,
    String? date,
  }) async {
    try {
      final response = await _dio.get(
        '/api/surveys',
        queryParameters: {
          'addiction_id': addictionId,
          if (date != null) 'date': date,
        },
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> submitSurvey(
      Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/surveys', data: data);
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Milestone endpoints
  Future<ApiResponse<List<dynamic>>> getMilestones(int addictionId) async {
    try {
      final response = await _dio.get(
        '/api/milestones',
        queryParameters: {'addiction_id': addictionId},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> createMilestone(
      Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/milestones', data: data);
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> claimMilestone(int id) async {
    try {
      final response = await _dio.put('/api/milestones/$id/claim');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============ Community Posts Endpoints ============

  Future<ApiResponse<List<Map<String, dynamic>>>> createPost({
    required String title,
    required String content,
    String? imageUrl,
    String visibility = 'public',
  }) async {
    try {
      final response = await _dio.post(
        '/api/community/posts',
        data: {
          'title': title,
          'content': content,
          'image_url': imageUrl,
          'visibility': visibility,
        },
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getPublicPosts({
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _dio.get('/api/community/posts', queryParameters: {
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      });
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getPostsSince(String since) async {
    try {
      final response = await _dio.get(
        '/api/community/posts/sync',
        queryParameters: {'since': since},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============ Comments Endpoints ============

  Future<ApiResponse<Map<String, dynamic>>> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        '/api/community/posts/$postId/comments',
        data: {'content': content},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getCommentsSince(String since) async {
    try {
      final response = await _dio.get(
        '/api/community/comments/sync',
        queryParameters: {'since': since},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============ Reactions Endpoints ============

  Future<ApiResponse<Map<String, dynamic>>> togglePostReaction(int postId) async {
    try {
      final response = await _dio.post('/api/community/posts/$postId/react');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getReactionsSince(String since) async {
    try {
      final response = await _dio.get(
        '/api/community/reactions/sync',
        queryParameters: {'since': since},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============ Heroes/Leaderboard Endpoints ============

  Future<ApiResponse<List<Map<String, dynamic>>>> getLeaderboard(String periodType) async {
    try {
      final response = await _dio.get('/api/leaderboard/$periodType');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getHeroesSince(String since) async {
    try {
      final response = await _dio.get(
        '/api/heroes/sync',
        queryParameters: {'since': since},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============ Notifications Endpoints ============

  Future<ApiResponse<List<Map<String, dynamic>>>> getUserNotifications({
    int? limit,
  }) async {
    try {
      final response = await _dio.get(
        '/api/notifications',
        queryParameters: {if (limit != null) 'limit': limit},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getNotificationsSince(String since) async {
    try {
      final response = await _dio.get(
        '/api/notifications/sync',
        queryParameters: {'since': since},
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<void>> markNotificationAsRead(int notificationId) async {
    try {
      final response = await _dio.put('/api/notifications/$notificationId/read');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Error handler
  ApiResponse<T> _handleError<T>(DioException error) {
    String message = 'An error occurred';
    
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        message = data['message'];
      } else {
        message = 'Server error: ${error.response!.statusCode}';
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Cannot connect to server. Please check your connection.';
    }

    return ApiResponse<T>(
      success: false,
      message: message,
      data: null,
    );
  }
}

// API Response model
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final dynamic errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] as T?,
      errors: json['errors'],
    );
  }
}
