import 'package:flutter/material.dart';
import 'package:kami_kerjain/models/booking_model.dart';
import 'package:kami_kerjain/services/auth_service.dart';
import 'package:kami_kerjain/services/booking_service.dart';
import 'package:kami_kerjain/utils/colors.dart';
import 'package:kami_kerjain/utils/helpers.dart';

class PenyediaBookingScreen extends StatefulWidget {
  const PenyediaBookingScreen({Key? key}) : super(key: key);

  @override
  _PenyediaBookingScreenState createState() => _PenyediaBookingScreenState();
}

class _PenyediaBookingScreenState extends State<PenyediaBookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingService _bookingService = BookingService();
  final AuthService _authService = AuthService();
  List<BookingModel> myBookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  void _loadBookings() {
    final user = _authService.user;
    if (user != null) {
      setState(() {
        myBookings = _bookingService.getBookingsByPenyedia(user.id);
      });
    }
  }

  void _updateBookingStatus(String bookingId, String status) {
    _bookingService.updateBookingStatus(bookingId, status);
    _loadBookings();
  }

  void _showConfirmationDialog(String bookingId, String title, String content, String newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.abuText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateBookingStatus(bookingId, newStatus);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status berhasil diperbarui')));
            },
            child: const Text('Ya', style: TextStyle(color: AppColors.biruNavy)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menunggu = myBookings.where((b) => b.status == 'pending').toList();
    final aktif = myBookings.where((b) => b.status == 'accepted' || b.status == 'in_progress').toList();
    final selesai = myBookings.where((b) => b.status == 'completed' || b.status == 'rejected' || b.status == 'cancelled').toList();

    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        title: const Text('Daftar Booking', style: TextStyle(color: AppColors.putih)),
        backgroundColor: AppColors.biruNavy,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.kuningLogo,
          labelColor: AppColors.kuningLogo,
          unselectedLabelColor: AppColors.putih,
          tabs: const [
            Tab(text: 'Menunggu'),
            Tab(text: 'Aktif'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(menunggu, isMenunggu: true),
          _buildBookingList(aktif, isAktif: true),
          _buildBookingList(selesai),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings, {bool isMenunggu = false, bool isAktif = false}) {
    if (bookings.isEmpty) {
      return const Center(child: Text('Tidak ada data booking', style: TextStyle(color: AppColors.abuText)));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final b = bookings[index];
        return Card(
          color: AppColors.putih,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(b.jasaTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(b.status.toUpperCase(), style: TextStyle(color: _getStatusColor(b.status), fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Pemesan: ${b.customerName}', style: const TextStyle(color: AppColors.abuText)),
                Text('Tanggal: ${b.createdAt.toLocal().toString().split(' ')[0]}', style: const TextStyle(color: AppColors.abuText)),
                const SizedBox(height: 8),
                Text(formatRupiah(b.price), style: const TextStyle(color: AppColors.hijauSukses, fontWeight: FontWeight.bold, fontSize: 16)),
                if (b.notes != null && b.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Catatan: ${b.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 12),
                if (isMenunggu)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => _showConfirmationDialog(b.id, 'Tolak Booking', 'Yakin ingin menolak booking ini?', 'rejected'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.merahError),
                        child: const Text('Tolak'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _showConfirmationDialog(b.id, 'Terima Booking', 'Yakin ingin menerima booking ini?', 'accepted'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.biruNavy),
                        child: const Text('Terima', style: TextStyle(color: AppColors.putih)),
                      ),
                    ],
                  ),
                if (isAktif)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => _showConfirmationDialog(b.id, 'Selesaikan Booking', 'Tandai booking ini sebagai selesai?', 'completed'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.kuningLogo),
                      child: const Text('Selesaikan', style: TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'accepted':
      case 'in_progress': return AppColors.biruNavy;
      case 'completed': return AppColors.hijauSukses;
      case 'rejected':
      case 'cancelled': return AppColors.merahError;
      default: return AppColors.abuText;
    }
  }
}
