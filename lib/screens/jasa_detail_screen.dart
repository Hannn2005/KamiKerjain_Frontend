import 'package:flutter/material.dart';
import '../models/jasa_model.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import 'booking_screen.dart';
import 'chat_detail_screen.dart';

class JasaDetailScreen extends StatelessWidget {
  final JasaModel jasa;

  const JasaDetailScreen({Key? key, required this.jasa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: AppColors.biruNavy,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(jasa.title, style: const TextStyle(color: Colors.white, fontSize: 16, shadows: [Shadow(color: Colors.black, blurRadius: 2)])),
              background: Container(
                color: AppColors.biruNavy.withOpacity(0.8),
                child: const Center(child: Icon(Icons.build, size: 80, color: Colors.white38)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatRupiah(jasa.price), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.kuningLogo)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.biruMuda, borderRadius: BorderRadius.circular(20)),
                        child: Text(jasa.category, style: const TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('${jasa.rating} (${jasa.totalReviews} ulasan)', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, color: Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text(jasa.location, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(jasa.description, style: const TextStyle(color: AppColors.abuText, height: 1.5)),
                  const SizedBox(height: 20),
                  const Text('Penyedia Jasa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.kuningLogo,
                        child: Text(
                          jasa.penyediaName.isNotEmpty ? jasa.penyediaName[0].toUpperCase() : 'P',
                          style: const TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(jasa.penyediaName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${jasa.rating}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(chatRoomId: 'temp', otherUserName: jasa.penyediaName)));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.biruNavy),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Icon(Icons.chat, color: AppColors.biruNavy),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(jasa: jasa)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.biruNavy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Booking Sekarang', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
