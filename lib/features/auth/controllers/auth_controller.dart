import 'package:flow_360/features/auth/repository/auth_repository.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/auth/models/auth_model.dart';
import 'package:flow_360/core/failure.dart';
import 'package:dartz/dartz.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  // State
  final Rxn<AuthModel> currentUser = Rxn<AuthModel>();
  final RxList<AuthModel> allUsers = <AuthModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  Future<bool> isUserLoggedIn() async {
    await _loadCurrentUser();
    return currentUser.value != null;
  }

  bool get isLoggedIn => currentUser.value != null;

  Future<void> _loadCurrentUser() async {
    final option = await authRepository.getCachedAuth();
    option.fold(
      () => currentUser.value = null,
      (auth) => currentUser.value = auth,
    );

    final users = await authRepository.getAllCachedUsers();
    allUsers.assignAll(users);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = null;

    final Either<Failure, AuthModel> result = await authRepository.login(
      username: username,
      password: password,
    );

    result.fold((failure) => errorMessage.value = failure.message, (auth) {
      currentUser.value = auth;
      if (!allUsers.any((u) => u.user.pk == auth.user.pk)) {
        authRepository.cacheUser(auth);
        allUsers.add(auth);
      }
    });

    isLoading.value = false;
  }

  Future<void> switchUser(AuthModel user) async {
    await authRepository.switchUser(user.user.pk.toString());
    currentUser.value = user;
  }

  Future<void> logoutCurrentUser() async {
    final userId = currentUser.value?.user.pk.toString();
    if (userId != null) {
      await authRepository.clearUser(userId);
      allUsers.removeWhere((u) => u.user.pk.toString() == userId);
      currentUser.value = null;
    }
  }

  Future<void> logoutAllUsers() async {
    await authRepository.clearAllUsers();
    currentUser.value = null;
    allUsers.clear();
  }
}
