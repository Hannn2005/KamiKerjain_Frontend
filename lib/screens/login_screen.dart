import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/auth_footer.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.putih,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/logo.png', height: 80),
                    const SizedBox(height: 30),
                    const CustomTextField(hintText: 'Email or Phone'),
                    const CustomTextField(hintText: 'password', isPassword: true),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.biruNavy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: AppColors.putih, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forget password ?',
                        style: TextStyle(color: AppColors.biruNavy),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            AuthFooter(
              text: 'Belum punya akun?',
              buttonText: 'Buat Akun',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}