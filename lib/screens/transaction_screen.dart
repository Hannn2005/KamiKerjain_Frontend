import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../models/booking_model.dart';
import 'booking_detail_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaksi', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.biruNavy,
          bottom: const TabBar(
            indicatorColor: AppColors.kuningLogo,
            labelColor: AppColors.kuningLogo,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TransactionList(type: 'semua'),
            _TransactionList(type: 'aktif'),
            _TransactionList(type: 'selesai'),
          ],
        ),
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final String type;
  const _TransactionList({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    List<BookingModel> bookings = [
      BookingModel(
        id: '1', 
        jasaId: 'j1', 
        jasaTitle: 'Jasa AC', 
        price: 150000.0, 
        status: 'pending', 
        createdAt: DateTime.now(), 
        penyediaName: 'Pak Budi',
        customerId: 'c1',
        customerName: 'Ahmad',
        penyediaId: 'p1'
      ),
      BookingModel(
        id: '2', 
        jasaId: 'j2', 
        jasaTitle: 'Jasa Kebersihan', 
        price: 200000.0, 
        status: 'completed', 
        createdAt: DateTime.now().subtract(const Duration(days: 2)), 
        penyediaName: 'Bu Siti',
        customerId: 'c1',
        customerName: 'Ahmad',
        penyediaId: 'p2'
      ),
    ];

    if (type == 'aktif') bookings = bookings.where((b) => b.status == 'pending' || b.status == 'in_progress').toList();
    if (type == 'selesai') bookings = bookings.where((b) => b.status == 'completed' || b.status == 'cancelled').toList();

    if (bookings.isEmpty) {
      return const Center(child: Text('Tidak ada transaksi', style: TextStyle(color: AppColors.abuText, fontSize: 16)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final b = bookings[index];
        Color statusColor = AppColors.abuText;
        String statusText = 'Tidak diketahui';
        if (b.status == 'pending') { statusColor = Colors.orange; statusText = 'Menunggu'; }
        else if (b.status == 'completed') { statusColor = AppColors.hijauSukses; statusText = 'Selesai'; }
        else if (b.status == 'in_progress') { statusColor = AppColors.biruNavy; statusText = 'Berlangsung'; }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(b.jasaTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Penyedia: ${b.penyediaName}'),
                const SizedBox(height: 4),
                Text(formatRupiah(b.price), style: const TextStyle(color: AppColors.kuningLogo, fontWeight: FontWeight.bold)),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: b)));
            },
          ),
        );
      },
    );
  }
}
