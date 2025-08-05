// services/auth_service.dart
import 'package:dartz/dartz.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/network/dio_client.dart';

class AuthService {
  final DioClient dioClient;
  AuthService({required this.dioClient});

  Future<Either<Failure, bool>> login(String username, String password) async {
    try {
      final response = await dioClient.dio.post(
        "/auth/login",
        data: {"username": username, "password": "password"},
      );

      if (response.statusCode == 200) { 

      }
      return left(
        Failure(
          message: "Please check your username and password and try again",
        ),
      );
    } catch (e) {
      return left(Failure(message: "Erick", error: null));
    }
  }
}
