import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../models/booking_model.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';
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

class _TransactionList extends StatefulWidget {
  final String type;
  const _TransactionList({Key? key, required this.type}) : super(key: key);

  @override
  State<_TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<_TransactionList> {
  final BookingService _bookingService = BookingService();
  List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final user = AuthService().currentUser;
    var list = user == null ? <BookingModel>[] : _bookingService.getBookingsByCustomer(user.id);

    if (widget.type == 'aktif') {
      list = list.where((b) => b.status == 'pending' || b.status == 'accepted' || b.status == 'in_progress').toList();
    } else if (widget.type == 'selesai') {
      list = list.where((b) => b.status == 'completed' || b.status == 'cancelled' || b.status == 'rejected').toList();
    }

    setState(() => _bookings = list);
  }

  void _confirmCancel(BookingModel b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pesanan?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.merahError)),
        content: Text('Pesanan "${b.jasaTitle}" akan dibatalkan. Tindakan ini tidak dapat diurungkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kembali', style: TextStyle(color: AppColors.abuText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final ok = _bookingService.cancelBookingByCustomer(b.id);
              _load();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok
                      ? 'Pesanan berhasil dibatalkan'
                      : 'Pesanan tidak dapat dibatalkan karena sudah diproses penyedia'),
                  backgroundColor: ok ? AppColors.hijauSukses : AppColors.merahError,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.merahError),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.blue;
      case 'in_progress': return AppColors.biruNavy;
      case 'completed': return AppColors.hijauSukses;
      case 'rejected': return AppColors.merahError;
      default: return AppColors.abuText;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bookings.isEmpty) {
      return const Center(child: Text('Tidak ada transaksi', style: TextStyle(color: AppColors.abuText, fontSize: 16)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final b = _bookings[index];
        final statusColor = _statusColor(b.status);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: b)));
              _load();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(b.jasaTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(getStatusLabel(b.status), style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Penyedia: ${b.penyediaName}'),
                  const SizedBox(height: 4),
                  Text(formatRupiah(b.price), style: const TextStyle(color: AppColors.kuningLogo, fontWeight: FontWeight.bold)),

                  // Tombol batalkan: hanya saat status masih menunggu
                  if (b.status == 'pending') ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmCancel(b),
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Batalkan Pesanan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.merahError,
                          side: const BorderSide(color: AppColors.merahError),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
