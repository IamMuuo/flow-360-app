import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final int pk;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String firstName;

  @HiveField(4)
  final String lastName;

  UserModel({
    required this.pk,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    pk: json['pk'],
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    firstName: json['first_name'] ?? '',
    lastName: json['last_name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "pk": pk,
    "username": username,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
  };
}
