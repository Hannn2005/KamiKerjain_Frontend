import 'package:flutter/material.dart';
import 'package:kami_kerjain/screens/penyedia/penyedia_home_screen.dart';
import 'package:kami_kerjain/screens/penyedia/kelola_jasa_screen.dart';
import 'package:kami_kerjain/screens/penyedia/penyedia_booking_screen.dart';
import 'package:kami_kerjain/screens/profile_screen.dart';
import 'package:kami_kerjain/utils/colors.dart';

class PenyediaMainLayout extends StatefulWidget {
  const PenyediaMainLayout({Key? key}) : super(key: key);

  @override
  _PenyediaMainLayoutState createState() => _PenyediaMainLayoutState();
}

class _PenyediaMainLayoutState extends State<PenyediaMainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PenyediaHomeScreen(),
    const PenyediaBookingScreen(),
    const KelolaJasaScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.putih,
        selectedItemColor: AppColors.kuningLogo,
        unselectedItemColor: AppColors.abuText,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jasa Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
