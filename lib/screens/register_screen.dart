import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/auth_footer.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                    const SizedBox(height: 60),
                    Image.asset('assets/logo.png', height: 80),
                    const SizedBox(height: 40),
                    const CustomTextField(hintText: 'username'),
                    const CustomTextField(hintText: 'Email or Phone'),
                    const CustomTextField(hintText: 'Password', isPassword: true),
                    const CustomTextField(hintText: 'Confirm Password', isPassword: true),
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
                            'Buat Akun',
                            style: TextStyle(color: AppColors.putih, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            AuthFooter(
              text: 'Sudah punya akun?',
              buttonText: 'Login',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}