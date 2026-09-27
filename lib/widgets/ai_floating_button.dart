import 'package:flutter/material.dart';
import '../screens/ai_chat_screen.dart';
import '../utils/colors.dart';

class AiFloatingButton extends StatelessWidget {
  const AiFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AiChatScreen(),
          ),
        );
      },
      backgroundColor: AppColors.kuningLogo,
      shape: CircleBorder(
        side: BorderSide(color: AppColors.biruNavy, width: 3),
      ),
      elevation: 8,
      child: const Icon(
        Icons.auto_awesome,
        color: AppColors.biruNavy,
        size: 28,
      ),
    );
  }
}