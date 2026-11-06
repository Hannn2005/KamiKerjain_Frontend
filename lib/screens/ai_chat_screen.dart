import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final Color navy = const Color(0xFF062D7A);
  final Color yellow = const Color(0xFFFFB800);
  final Color background = const Color(0xFFF5F5F5);

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();

    if (message.isEmpty) return;

    // Untuk sekarang hanya membersihkan input.
    // Logic AI/API bisa ditambahkan nanti.
    _messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesan dikirim'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _selectSuggestion(String text) {
    _messageController.text = text;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _messageController.text.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // =========================
      // HEADER
      // =========================
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Kami AI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // BODY
      // =========================
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                30,
                20,
                20,
              ),
              child: Column(
                children: [
                  // AI ICON
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: yellow,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: navy,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // GREETING
                  const Text(
                    'Halo! 👋',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Saya Kami AI Assistant',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF062D7A),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Ada yang bisa saya bantu?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // =========================
                  // SUGGESTION TITLE
                  // =========================
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Coba tanyakan sesuatu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SUGGESTION CARDS
                  _suggestionCard(
                    icon: Icons.search,
                    title: 'Cari jasa',
                    subtitle: 'Bantu saya mencari jasa',
                    onTap: () {
                      _selectSuggestion(
                        'Bantu saya mencari jasa',
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  _suggestionCard(
                    icon: Icons.recommend,
                    title: 'Rekomendasi jasa',
                    subtitle: 'Berikan rekomendasi jasa',
                    onTap: () {
                      _selectSuggestion(
                        'Berikan rekomendasi jasa',
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  _suggestionCard(
                    icon: Icons.help_outline,
                    title: 'Butuh bantuan',
                    subtitle: 'Saya membutuhkan bantuan',
                    onTap: () {
                      _selectSuggestion(
                        'Saya membutuhkan bantuan',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // MESSAGE INPUT
          // =========================
          Container(
            padding: const EdgeInsets.fromLTRB(
              14,
              10,
              14,
              14,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Tulis pesan...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // SEND BUTTON
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: navy,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: yellow,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SUGGESTION CARD
  // =========================

  Widget _suggestionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF062D7A),
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: navy,
            ),
          ],
        ),
      ),
    );
  }
}