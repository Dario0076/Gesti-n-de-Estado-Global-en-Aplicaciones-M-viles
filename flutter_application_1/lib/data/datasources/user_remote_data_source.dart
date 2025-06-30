import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/user.dart';

abstract class UserRemoteDataSource {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
  Future<List<Post>> getPostsByUserId(int userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await dio.get('${AppConstants.apiBaseUrl}/users');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<User> getUserById(int id) async {
    try {
      final response = await dio.get('${AppConstants.apiBaseUrl}/users/$id');
      
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<Post>> getPostsByUserId(int userId) async {
    try {
      final response = await dio.get('${AppConstants.apiBaseUrl}/posts?userId=$userId');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
