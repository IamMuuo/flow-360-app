import 'package:dio/dio.dart';
import 'package:flow_360/core/network/auth_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio dio;

  DioClient({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: "http://147.93.155.29:8000/",
              // baseUrl: "http://192.168.100.21:8000/",
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
              headers: {"Content-Type": "application/json"},
            ),
          ) {
    this.dio.interceptors.add(
      PrettyDioLogger(
        error: true,
        request: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        requestBody: true,
      ),
    );
    this.dio.interceptors.add(AuthInterceptor());
  }
}
