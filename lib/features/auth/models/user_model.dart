import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String? firstName;

  @HiveField(3)
  final String? lastName;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final bool isSuperuser;

  @HiveField(6)
  final bool isStaff;

  @HiveField(7)
  final bool isActive;

  @HiveField(8)
  final DateTime dateJoined;

  @HiveField(9)
  final DateTime? lastLogin;

  @HiveField(10)
  final String role;

  @HiveField(11)
  final String? phoneNumber;

  @HiveField(12)
  final String? profilePicture;

  @HiveField(13)
  final String? organization;

  @HiveField(14)
  final String? station;

  @HiveField(15)
  final List<int> groups;

  UserModel({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.email,
    required this.isSuperuser,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    this.lastLogin,
    required this.role,
    this.phoneNumber,
    this.profilePicture,
    this.organization,
    this.station,
    required this.groups,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      isSuperuser: json['is_superuser'],
      isStaff: json['is_staff'],
      isActive: json['is_active'],
      dateJoined: DateTime.parse(json['date_joined']),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      role: json['role'],
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
      organization: json['organization'],
      station: json['station'],
      groups: List<int>.from(json['groups'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'is_superuser': isSuperuser,
      'is_staff': isStaff,
      'is_active': isActive,
      'date_joined': dateJoined.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'role': role,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'organization': organization,
      'station': station,
      'groups': groups,
    };
  }
}
