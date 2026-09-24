import 'package:flutter/material.dart';
import 'utils/routes.dart'; // Import file rute

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
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}