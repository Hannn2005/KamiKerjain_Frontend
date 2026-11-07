import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/auth_footer.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await AuthService().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      final user = AuthService().currentUser;
      if (user?.role == 'admin') {
        // Direct route to Admin Dashboard
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else if (user?.role == 'penyedia') {
        if (user?.status == 'pending') {
          AuthService().logout();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.hourglass_top, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Akun Sedang Diverifikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.biruNavy)),
                ],
              ),
              content: const Text(
                'Pendaftaran akun Anda sebagai Penyedia Jasa saat ini sedang dalam proses verifikasi oleh Admin KamiKerjain.\n\n'
                'Admin sedang meninjau berkas CV dan bukti pekerjaan Anda. Silakan hubungi admin atau login kembali setelah akun disetujui.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Mengerti', style: TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        } else if (user?.status == 'rejected') {
          final reason = user?.rejectionReason ?? 'Dokumen CV/Portofolio belum memenuhi standar kualifikasi';
          AuthService().logout();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.cancel, color: AppColors.merahError),
                  SizedBox(width: 8),
                  Text('Pendaftaran Ditolak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.merahError)),
                ],
              ),
              content: Text('Mohon maaf, pengajuan akun mitra Anda ditolak oleh Admin dengan alasan:\n\n"$reason"'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tutup', style: TextStyle(color: AppColors.biruNavy)),
                ),
              ],
            ),
          );
        } else {
          // Approved provider
          Navigator.pushReplacementNamed(context, AppRoutes.penyediaMainLayout);
        }
      } else {
        // Customer
        Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email atau password salah'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.putih,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                      Image.asset('assets/KamiKerjain.png', height: 140),
                      const SizedBox(height: 8),
                      Image.asset('assets/logo.png', height: 70),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.biruNavy),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hintText: 'Password',
                        isPassword: _obscurePassword,
                        controller: _passwordController,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.biruNavy),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.biruNavy,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.biruNavy,
                              disabledBackgroundColor: AppColors.biruNavy.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.putih,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: AppColors.putih,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur reset password akan segera hadir'),
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa password?',
                          style: TextStyle(color: AppColors.biruNavy),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Hint akun testing termasuk ADMIN & PENYEDIA PENDING
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.biruNavy.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.biruNavy.withOpacity(0.12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: AppColors.biruNavy),
                                SizedBox(width: 6),
                                Text(
                                  'Akun Uji Coba Demo:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.biruNavy,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text('• Admin (Acc Mitra): admin@kamikerjain.com / admin123', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.purple)),
                            Text('• Calon Mitra (Pending): calon_mitra@test.com / 123456', style: TextStyle(fontSize: 11, color: Colors.deepOrange)),
                            Text('• Penyedia Aktif: penyedia@test.com / 123456', style: TextStyle(fontSize: 11, color: AppColors.biruNavy)),
                            Text('• Customer: customer@test.com / 123456', style: TextStyle(fontSize: 11, color: Colors.black87)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            AuthFooter(
              text: 'Belum punya akun?',
              buttonText: 'Buat Akun',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
            ),
          ],
        ),
      ),
    );
  }
}
