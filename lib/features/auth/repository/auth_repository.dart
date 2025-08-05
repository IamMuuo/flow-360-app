import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flow_360/core/core.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/auth/models/auth_model.dart';

class AuthRepository {
  final DioClient dioClient;

  static const String _authBox = 'authBox';
  static const String _metaBox = 'metaBox';
  static const String _currentUserKey = 'current_user_id';

  AuthRepository({required this.dioClient});

  Future<Either<Failure, AuthModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login/',
        data: {'username': username, 'password': password},
      );

      final data = response.data;
      final auth = AuthModel.fromJson(data);

      // Ensure boxes are open
      await HiveService.openBox<AuthModel>(_authBox);
      await HiveService.openBox<String>(_metaBox);

      // Save auth object
      await HiveService.put<AuthModel>(_authBox, auth.user.pk.toString(), auth);

      // Set current user
      await HiveService.put<String>(
        _metaBox,
        _currentUserKey,
        auth.user.pk.toString(),
      );

      return right(auth);
    } on DioException catch (e) {
      return left(
        Failure(
          message: e.response?.data['detail'] ?? 'Login failed',
          error: e,
        ),
      );
    } catch (e) {
      return left(Failure(message: 'Unexpected error', error: e));
    }
  }

  Future<Option<AuthModel>> getCachedAuth() async {
    await HiveService.openBox<AuthModel>(_authBox);
    await HiveService.openBox<String>(_metaBox);

    final currentUserId = HiveService.get<String>(_metaBox, _currentUserKey);
    if (currentUserId == null) return none();

    final auth = HiveService.get<AuthModel>(_authBox, currentUserId);
    return optionOf(auth);
  }

  /// Get all cached users
  Future<List<AuthModel>> getAllCachedUsers() async {
    await HiveService.openBox<AuthModel>(_authBox);
    return HiveService.getBox<AuthModel>(_authBox).values.toList();
  }

  /// Switch current user by ID
  Future<void> switchUser(String userId) async {
    await HiveService.openBox<String>(_metaBox);
    await HiveService.put<String>(_metaBox, _currentUserKey, userId);
  }

  /// Clear a specific user
  Future<void> clearUser(String userId) async {
    await HiveService.openBox<AuthModel>(_authBox);
    await HiveService.delete<AuthModel>(_authBox, userId);

    final currentId = HiveService.get<String>(_metaBox, _currentUserKey);
    if (currentId == userId) {
      await HiveService.delete<String>(_metaBox, _currentUserKey);
    }
  }

  /// Clear everything
  Future<void> clearAllUsers() async {
    await HiveService.openBox<AuthModel>(_authBox);
    await HiveService.openBox<String>(_metaBox);
    await HiveService.clear(_authBox);
    await HiveService.clear(_metaBox);
  }

  Future<void> clearAuth() async {
    await HiveService.openBox<AuthModel>(_authBox);
    await HiveService.openBox<String>(_metaBox);

    final currentUserId = HiveService.get<String>(_metaBox, _currentUserKey);
    if (currentUserId != null) {
      await HiveService.delete<AuthModel>(_authBox, currentUserId);
    }

    await HiveService.delete<String>(_metaBox, _currentUserKey);
  }

  Future<void> cacheUser(AuthModel user) async {
    await HiveService.openBox<AuthModel>(_authBox);
    final box = HiveService.getBox<AuthModel>(_authBox);
    await box.put(user.user.pk.toString(), user);
  }
}
