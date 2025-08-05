import 'package:hive/hive.dart';
import 'user_model.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 2)
class AuthModel extends HiveObject {
  @HiveField(0)
  final String access;

  @HiveField(1)
  final String refresh;

  @HiveField(2)
  final UserModel user;

  AuthModel({required this.access, required this.refresh, required this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    access: json['access'] ?? '',
    refresh: json['refresh'] ?? '',
    user: UserModel.fromJson(json['user']),
  );

  Map<String, dynamic> toJson() => {
    "access": access,
    "refresh": refresh,
    "user": user.toJson(),
  };
}
