import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/auth_footer.dart';

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
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Image.asset('assets/KamiKerjain.png', height: 180),
                      const SizedBox(height: 10),
                      Image.asset('assets/logo.png', height: 100),
                      const CustomTextField(hintText: 'Email'),
                      const CustomTextField(
                        hintText: 'Password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.biruNavy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                backgroundColor: Colors.transparent,
                                color: AppColors.putih,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forget password ?',
                          style: TextStyle(color: AppColors.biruNavy),
                        ),
                      ),
                      const SizedBox(height: 50),
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