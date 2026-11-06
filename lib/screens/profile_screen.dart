import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

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
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.kuningLogo,
                    child: CircleAvatar(
                      radius: 51,
                      backgroundColor: AppColors.putih,
                      child: Text(
                        user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.biruNavy),
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
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.biruNavy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${user.email} | ${user.phone}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.kuningLogo.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.role == 'penyedia' ? 'Penyedia Jasa' : 'Customer',
                style: const TextStyle(
                  color: AppColors.biruNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1, color: Colors.black12),
            _buildProfileMenu(
              context,
              icon: Icons.person_outline,
              title: 'Informasi Akun',
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
            if (user.role == 'penyedia')
              _buildProfileMenu(
                context,
                icon: Icons.document_scanner_outlined,
                title: 'AI Resume Reviewer',
                onTap: () => Navigator.pushNamed(context, AppRoutes.aiResume),
              ),
            _buildProfileMenu(
              context,
              icon: Icons.history,
              title: 'Riwayat Transaksi',
              onTap: () => Navigator.pushNamed(context, AppRoutes.transaction),
            ),
            _buildProfileMenu(
              context,
              icon: Icons.help_outline,
              title: 'Pusat Bantuan',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pusat Bantuan belum tersedia')),
                );
              },
            ),
            const Divider(thickness: 1, color: Colors.black12),
            _buildProfileMenu(
              context,
              icon: Icons.logout,
              title: 'Keluar',
              isLogout: true,
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, {required IconData icon, required String title, bool isLogout = false, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withOpacity(0.1)
              : AppColors.biruNavy.withOpacity(0.1),
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
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}