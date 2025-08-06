import 'package:dio/dio.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get the current user from the AuthController
    final auth = Get.find<AuthController>().currentUser.value;

    // Skip the interceptor for the login endpoint
    if (options.path.contains("/auth/login")) {
      return handler.next(options);
    }

    // Add the access token to the header if it exists
    if (auth != null && auth.access.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${auth.access}';
    }

    // Continue with the request
    return handler.next(options);
  }
}
