// domain/models/user.dart
class UserModel {
  final String id, name, email, role;
  final String token;

  UserModel({required this.id, required this.name, required this.email, required this.role, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        role: json['user']['role'],
        token: json['token'],
      );
}
