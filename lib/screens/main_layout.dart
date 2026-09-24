import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditukar-tukar
  final List<Widget> _screens = [
    const HomeScreen(), // Index 0: Home
    const Center(child: Text('Halaman Transaksi Belum Dibuat')), // Index 1: Transaksi (Placeholder)
    const ProfileScreen(), // Index 2: Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berubah sesuai tab yang diklik
      body: _screens[_selectedIndex],
      // Memanggil widget BottomNavbar yang sudah dibuat
      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}