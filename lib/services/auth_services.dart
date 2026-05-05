// services/auth_services.dart
import 'dart:convert';
import 'package:edubridge/domain/models/user_model.dart';
import 'package:edubridge/utils/constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final client = http.Client();

  Future<UserModel> signup(Map<String, dynamic> data) async {
    final res = await client.post(
      Uri.parse('$kBaseUrl/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message']);
    }
    return UserModel.fromJson(jsonDecode(res.body));
  }

  Future<UserModel> login(Map<String, dynamic> data) async {
    final res = await client.post(
      Uri.parse('$kBaseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }
    return UserModel.fromJson(jsonDecode(res.body));
  }
}
