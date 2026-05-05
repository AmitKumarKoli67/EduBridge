// routes/app_routes.dart
import 'package:edubridge/features/presentation/auth/screens/dashboard_screen.dart';
import 'package:edubridge/features/presentation/auth/screens/home_screen.dart';
import 'package:edubridge/features/presentation/auth/screens/login_screen.dart';
import 'package:edubridge/features/presentation/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    signup: (_) => const SignupScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const HomeScreen(), 
    dashboard: (_) => DashboardScreen(),
  };
}
