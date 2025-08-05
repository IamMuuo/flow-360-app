import 'package:dio/dio.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/auth/models/auth_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AuthInterceptor extends Interceptor {
  final Box<AuthModel> authBox;

  AuthInterceptor(this.authBox);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final auth = Get.find<AuthController>().currentUser.value;

    if (options.path.contains("/auth/login")) {
      return handler.next(options);
    }

    if (auth != null && auth.access.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${auth.access}';
    }

    return handler.next(options);
  }
}
