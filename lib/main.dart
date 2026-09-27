import 'package:flutter/material.dart';
import 'utils/routes.dart';
import 'utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kami Kerjain',
      theme: ThemeData(
        colorSchemeSeed: AppColors.biruNavy,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.putih,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.biruNavy,
          foregroundColor: AppColors.putih,
          elevation: 0,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}