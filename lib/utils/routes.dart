import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/main_layout.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String mainLayout = '/mainLayout';

  // Kumpulan rute yang akan didaftarkan ke sistem utama
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      mainLayout: (context) => const MainLayout(),
    };
  }
}