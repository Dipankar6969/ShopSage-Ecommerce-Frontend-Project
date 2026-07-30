import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class ApiService {
  late final Dio _dio;
  final GetStorage _storage = GetStorage();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read<String>('authToken');
          if (token != null && token.isNotEmpty) {
            options.headers['Cookie'] = 'authToken=$token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/api/products/categories');
      if (response.statusCode == 200) {
        return List<String>.from(response.data as List);
      }
      throw Exception('Failed to load categories');
    } on DioException catch (error) {
      final message = _getErrorMessage(
        error,
        defaultMessage: 'Failed to load categories',
      );
      throw Exception(message);
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token != null) {
        _storage.write('authToken', token);
      }
      return UserModel.fromJson(data);
    } on DioException catch (error) {
      final message = _getErrorMessage(error, defaultMessage: 'Login failed');
      throw Exception(message);
    }
  }

  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/auth/register', data: data);
      final responseData = response.data as Map<String, dynamic>;
      final token = responseData['token'] as String?;
      if (token != null) {
        _storage.write('authToken', token);
      }
      return UserModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getErrorMessage(
        error,
        defaultMessage: 'Registration failed',
      );
      throw Exception(message);
    }
  }

  Future<UserModel> uploadProfileImage(String filePath) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final response = await _dio.put(
        '/api/users/profile-image',
        data: formData,
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      final message = _getErrorMessage(
        error,
        defaultMessage: 'Failed to upload profile image',
      );
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> payOrderViaKhalti(String orderId) async {
    try {
      final response = await _dio.put('/api/orders/$orderId/payment/khalti');
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (error) {
      final message = _getErrorMessage(
        error,
        defaultMessage: 'Khalti payment initialization failed',
      );
      throw Exception(message);
    }
  }

  Future<void> logout() async {
    await _storage.remove('authToken');
  }

  Future<String?> getStoredToken() async {
    return _storage.read<String>('authToken');
  }

  String _getErrorMessage(
    DioException error, {
    required String defaultMessage,
  }) {
    if (error.response?.data != null) {
      final responseData = error.response!.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          return responseData['message'].toString();
        }
        return responseData.toString();
      }
      return responseData.toString();
    }
    return defaultMessage;
  }
}
