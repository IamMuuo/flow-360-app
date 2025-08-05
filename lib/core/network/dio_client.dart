import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: "http://192.168.100.21:8000/",
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
              headers: {"Content-Type": "application/json"},
            ),
          ) {
    this.dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }
}
