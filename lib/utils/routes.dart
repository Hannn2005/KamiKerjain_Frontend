import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/main_layout.dart';
import '../screens/search_screen.dart';
import '../screens/chat_list_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/ai_resume_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/penyedia/penyedia_main_layout.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainLayout = '/mainLayout';
  static const String penyediaMainLayout = '/penyediaMainLayout';
  static const String search = '/search';
  static const String chatList = '/chatList';
  static const String notification = '/notification';
  static const String transaction = '/transaction';
  static const String aiResume = '/aiResume';
  static const String editProfile = '/editProfile';

  // Kumpulan rute yang akan didaftarkan ke sistem utama
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      mainLayout: (context) => const MainLayout(),
      penyediaMainLayout: (context) => const PenyediaMainLayout(),
      search: (context) => const SearchScreen(),
      chatList: (context) => const ChatListScreen(),
      notification: (context) => const NotificationScreen(),
      transaction: (context) => const TransactionScreen(),
      aiResume: (context) => const AIResumeScreen(),
      editProfile: (context) => const EditProfileScreen(),
    };
  }
}