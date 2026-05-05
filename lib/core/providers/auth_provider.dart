// providers/auth_provider.dart
import 'package:edubridge/domain/models/user_model.dart';
import 'package:edubridge/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  final _authService = AuthService();

  UserModel? _user;
  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> signup(String name, String email, String password, String role) async {
    _user = await _authService.signup({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
    await _storage.write(key: 'token', value: _user!.token);
    notifyListeners();
  }

  Future<void> login(String email, String password, String role) async {
    _user = await _authService.login({
      'email': email,
      'password': password,
      'role': role,
    });
    await _storage.write(key: 'token', value: _user!.token);
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return false;
    // In a real app, you'd validate the token with the backend here.
    // For now, we'll assume it's valid if it exists to make the demo smooth.
    return true;
  }
}
