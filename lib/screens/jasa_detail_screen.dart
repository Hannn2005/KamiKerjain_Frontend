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
              title: Text(
                jasa.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                ),
              ),
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
                  // Price Header with Scheme Label
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.kuningLogo.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              jasa.formattedPriceType,
                              style: const TextStyle(
                                color: AppColors.biruNavy,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.biruMuda,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              jasa.category,
                              style: const TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            formatRupiah(jasa.price),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.kuningLogo),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              jasa.priceUnit,
                              style: const TextStyle(fontSize: 14, color: AppColors.abuText, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

                  // Info Dynamic Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.biruMuda.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.biruNavy.withOpacity(0.2)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: AppColors.biruNavy, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Harga tertera adalah tarif dasar/estimasi awal. Anda dapat memilih layanan tambahan sesuai kebutuhan Anda pada saat pemesanan.',
                            style: TextStyle(fontSize: 12, color: AppColors.biruNavy, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('Deskripsi Layanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(jasa.description, style: const TextStyle(color: AppColors.abuText, height: 1.5)),
                  const SizedBox(height: 20),

                  // Available Add-ons / Options Section
                  if (jasa.options.isNotEmpty) ...[
                    const Text('Layanan / Opsi Tambahan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Dapat dipilih pada layar booking:', style: TextStyle(fontSize: 12, color: AppColors.abuText)),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: jasa.options.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final opt = jasa.options[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.add_task, color: AppColors.biruNavy, size: 20),
                            title: Text(opt.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            trailing: Text(
                              '+ ${formatRupiah(opt.price)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.hijauSukses, fontSize: 13),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(
                          chatRoomId: 'temp',
                          otherUserName: jasa.penyediaName,
                        ),
                      ),
                    );
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
                  child: const Text('Pilih Opsi & Booking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
