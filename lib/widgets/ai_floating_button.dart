import 'package:flutter/material.dart';
import '../screens/ai_chat_screen.dart';

class AiFloatingButton extends StatelessWidget {
  const AiFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 18,
      bottom: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AiChatScreen(),
            ),
          );
        },
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFFFB800),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00246B),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF00246B),
            size: 28,
          ),
        ),
      ),
    );
  }
}