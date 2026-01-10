import 'package:dio/dio.dart';
import '../data/storage/token_storage.dart';
import 'api_config.dart';

class ApiService {
  // A single, static instance of ApiService is created when the class is loaded
  static final ApiService _instance = ApiService._internal();
  // Factory constructor returns the same instance every time
  factory ApiService() => _instance;
  // Private named constructor prevents external instantiation
  ApiService._internal();

  // Base URL from ApiConfig - supports environment switching
  static final String baseUrl = ApiConfig.getBaseUrl();
  
  late final Dio _dio;

  void initialize() {
    print('🌐 API Service initialized with baseUrl: $baseUrl');
    print('🔧 Environment: ${ApiConfig.environment}');
    
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30), // Increased for Render cold starts
        receiveTimeout: const Duration(seconds: 30),
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
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // Merge user data with email and password
      final requestData = Map<String, dynamic>.from(userData);
      requestData['email'] = email;
      requestData['password'] = password;
      
      final response = await _dio.post(
        '/api/auth/register',
        data: requestData,
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

  // Health check with short timeouts to quickly detect unreachable backend
  Future<bool> healthCheck({
    Duration connectTimeout = const Duration(seconds: 5),
    Duration receiveTimeout = const Duration(seconds: 5),
  }) async {
    try {
      final response = await _dio.get(
        '/health',
        options: Options(
          sendTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return (data['success'] == true);
        }
        return true;
      }
      return false;
    } on DioException catch (_) {
      return false;
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
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        '/api/community/posts',
        data: {
          'content': content,
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

  Future<ApiResponse<Map<String, dynamic>>> deletePost(int postId) async {
    try {
      final response = await _dio.delete('/api/community/posts/$postId');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============ Comments Endpoints ============

  Future<ApiResponse<List<Map<String, dynamic>>>> getComments({
    required int postId,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _dio.get(
        '/api/community/posts/$postId/comments',
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

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

  Future<ApiResponse<Map<String, dynamic>>> deleteComment(int commentId) async {
    try {
      final response = await _dio.delete('/api/community/comments/$commentId');
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

  // ============ Heroes/Leaderboard Endpoints ============

  Future<ApiResponse<List<Map<String, dynamic>>>> getHeroesLastMonth() async {
    try {
      final response = await _dio.get('/api/community/heroes/last-month');
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
