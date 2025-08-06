import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flow_360/core/core.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/auth/models/auth_model.dart';

class AuthRepository {
  final DioClient _dioClient;
  final HiveService _hiveService; // Inject HiveService

  static const String _authBox = 'authBox';
  static const String _metaBox = 'metaBox';
  static const String _currentUserKey = 'current_user_id';

  // The constructor now receives its dependencies
  AuthRepository({
    required DioClient dioClient,
    required HiveService hiveService,
  }) : _dioClient = dioClient,
       _hiveService = hiveService;

  Future<Either<Failure, AuthModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login/',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode != 200) {
        return left(
          Failure(
            message:
                response.data['detail'] ??
                response.data['error'] ??
                'Login failed',
          ),
        );
      }
      final authData = response.data;
      final profileResponse = await _dioClient.dio.get(
        '/accounts/me',
        options: Options(
          headers: {"Authorization": "Bearer ${authData['access']}"},
        ),
      );

      if (profileResponse.statusCode != 200) {
        return left(
          Failure(
            message:
                response.data['detail'] ??
                response.data['error'] ??
                'Failed to fetch your profile from remote',
          ),
        );
      }

      authData["user"] = profileResponse.data;
      final auth = AuthModel.fromJson(authData);

      // Use the injected HiveService instance
      // await _hiveService.openBox<AuthModel>(_authBox);
      // await _hiveService.openBox<String>(_metaBox);

      // Save auth object
      await _hiveService.put<AuthModel>(
        _authBox,
        auth.user.id.toString(),
        auth,
      );

      // Set current user
      await _hiveService.put<String>(
        _metaBox,
        _currentUserKey,
        auth.user.id.toString(),
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
    // Open boxes here to ensure they're available, or rely on the global init
    // await _hiveService.openBox<AuthModel>(_authBox);
    // await _hiveService.openBox<String>(_metaBox);
    //
    final currentUserId = _hiveService.get<String>(_metaBox, _currentUserKey);
    if (currentUserId == null) return none();

    final auth = _hiveService.get<AuthModel>(_authBox, currentUserId);
    return optionOf(auth);
  }

  Future<List<AuthModel>> getAllCachedUsers() async {
    await _hiveService.openBox<AuthModel>(_authBox);
    return _hiveService.getBox<AuthModel>(_authBox).values.toList();
  }

  Future<void> switchUser(String userId) async {
    await _hiveService.openBox<String>(_metaBox);
    await _hiveService.put<String>(_metaBox, _currentUserKey, userId);
  }

  Future<void> clearUser(String userId) async {
    await _hiveService.openBox<AuthModel>(_authBox);
    await _hiveService.delete<AuthModel>(_authBox, userId);

    final currentId = _hiveService.get<String>(_metaBox, _currentUserKey);
    if (currentId == userId) {
      await _hiveService.delete<String>(_metaBox, _currentUserKey);
    }
  }

  Future<void> clearAllUsers() async {
    await _hiveService.openBox<AuthModel>(_authBox);
    await _hiveService.openBox<String>(_metaBox);
    await _hiveService.clear(_authBox);
    await _hiveService.clear(_metaBox);
  }

  Future<void> clearAuth() async {
    await _hiveService.openBox<AuthModel>(_authBox);
    await _hiveService.openBox<String>(_metaBox);

    final currentUserId = _hiveService.get<String>(_metaBox, _currentUserKey);
    if (currentUserId != null) {
      await _hiveService.delete<AuthModel>(_authBox, currentUserId);
    }

    await _hiveService.delete<String>(_metaBox, _currentUserKey);
  }

  Future<void> cacheUser(AuthModel user) async {
    await _hiveService.openBox<AuthModel>(_authBox);
    await _hiveService.put<AuthModel>(_authBox, user.user.id.toString(), user);
  }
}
