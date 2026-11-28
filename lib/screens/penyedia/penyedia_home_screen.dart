import 'package:flutter/material.dart';
import 'package:kami_kerjain/models/jasa_model.dart';
import 'package:kami_kerjain/models/booking_model.dart';
import 'package:kami_kerjain/services/auth_service.dart';
import 'package:kami_kerjain/services/jasa_service.dart';
import 'package:kami_kerjain/services/booking_service.dart';
import 'package:kami_kerjain/services/api_client.dart';
import 'package:kami_kerjain/utils/routes.dart';
import 'package:kami_kerjain/utils/colors.dart';
import 'package:kami_kerjain/utils/helpers.dart';
import 'package:kami_kerjain/screens/penyedia/tambah_jasa_screen.dart';

class PenyediaHomeScreen extends StatefulWidget {
  const PenyediaHomeScreen({Key? key}) : super(key: key);

  @override
  _PenyediaHomeScreenState createState() => _PenyediaHomeScreenState();
}

class _PenyediaHomeScreenState extends State<PenyediaHomeScreen> {
  final AuthService _authService = AuthService();
  final JasaService _jasaService = JasaService();
  final BookingService _bookingService = BookingService();

  List<BookingModel> recentBookings = [];
  List<JasaModel> myJasa = [];
  int totalJasa = 0;
  int bookingMasuk = 0;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = _authService.user;
    if (user == null) return;

    try {
      final results = await Future.wait([
        _jasaService.getJasaByPenyedia(user.id),
        _bookingService.getMyBookings(),
      ]);
      final allJasa = results[0] as List<JasaModel>;
      final allBookings = results[1] as List<BookingModel>;

      if (!mounted) return;
      setState(() {
        myJasa = allJasa;
        totalJasa = allJasa.length;
        recentBookings = allBookings.take(5).toList();
        bookingMasuk = allBookings.where((b) => b.status == 'pending').length;

        // Rating rata-rata hanya dari jasa yang sudah punya ulasan.
        final rated = allJasa.where((j) => j.totalReviews > 0).toList();
        averageRating = rated.isEmpty
            ? 0.0
            : rated.fold<double>(0, (sum, item) => sum + item.rating) / rated.length;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.user;
    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        backgroundColor: AppColors.biruNavy,
        title: Text(
          'Halo, ${user?.username ?? 'Penyedia'}!',
          style: const TextStyle(color: AppColors.putih, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.putih),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notification),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsRow(),
              const SizedBox(height: 24),
              const Text(
                'Booking Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.biruNavy),
              ),
              const SizedBox(height: 12),
              _buildRecentBookings(),
              const SizedBox(height: 24),
              const Text(
                'Jasa Saya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.biruNavy),
              ),
              const SizedBox(height: 12),
              _buildMyJasa(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahJasaScreen()),
          );
          _loadData();
        },
        backgroundColor: AppColors.kuningLogo,
        child: const Icon(Icons.add, color: AppColors.biruNavy),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('Total Jasa', totalJasa.toString(), Icons.work),
        _buildStatCard('Booking\nMasuk', bookingMasuk.toString(), Icons.book_online),
        _buildStatCard('Rating', averageRating.toStringAsFixed(1), Icons.star),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: AppColors.putih,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.kuningLogo, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.biruNavy),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.abuText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBookings() {
    if (recentBookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Belum ada booking', style: TextStyle(color: AppColors.abuText)),
        ),
      );
    }
    return Column(
      children: recentBookings.map((b) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: AppColors.putih,
        child: ListTile(
          title: Text(b.jasaTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${b.customerName} - ${b.status}'),
          trailing: Text(
            formatRupiah(b.price),
            style: const TextStyle(color: AppColors.hijauSukses, fontWeight: FontWeight.bold),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildMyJasa() {
    if (myJasa.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Belum ada jasa terdaftar', style: TextStyle(color: AppColors.abuText)),
        ),
      );
    }
    return Column(
      children: myJasa.take(3).map((j) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: AppColors.putih,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.biruMuda,
            child: Icon(Icons.work, color: AppColors.biruNavy),
          ),
          title: Text(j.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(j.category),
          trailing: Icon(j.isActive ? Icons.check_circle : Icons.cancel, color: j.isActive ? AppColors.hijauSukses : AppColors.abuText),
        ),
      )).toList(),
    );
  }
}
