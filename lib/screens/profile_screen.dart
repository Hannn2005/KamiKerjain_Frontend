import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.putih,
      appBar: AppBar(
        backgroundColor: AppColors.biruNavy,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.putih,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.biruNavy,
                    child: CircleAvatar(
                      radius: 51,
                      backgroundColor: AppColors.putih,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.biruNavy,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: AppColors.kuningLogo,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.putih, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.biruNavy,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Marcello',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.biruNavy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'marcello@email.com | +62 812-3456-7890',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.kuningLogo.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Customer',
                style: TextStyle(
                  color: AppColors.biruNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1, color: Colors.black12),
            _buildProfileMenu(Icons.person_outline, 'Informasi Akun'),
            _buildProfileMenu(Icons.security, 'Keamanan & Kata Sandi'),
            _buildProfileMenu(Icons.history, 'Riwayat Transaksi'),
            _buildProfileMenu(Icons.help_outline, 'Pusat Bantuan'),
            const Divider(thickness: 1, color: Colors.black12),
            _buildProfileMenu(Icons.logout, 'Keluar', isLogout: true),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withValues(alpha: 0.1)
              : AppColors.biruNavy.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : AppColors.biruNavy,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: isLogout
          ? null
          : const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {},
    );
  }
}