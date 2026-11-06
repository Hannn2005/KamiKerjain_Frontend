import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class BookingDetailScreen extends StatefulWidget {
  final BookingModel booking;
  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  double _rating = 0;
  final _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.biruNavy,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getStatusLabel(booking.status),
                      style: TextStyle(
                        color: _getStatusColor(booking.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(booking.jasaTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Penyedia: ${booking.penyediaName}'),
                  const SizedBox(height: 4),
                  Text('Customer: ${booking.customerName}'),
                  const SizedBox(height: 4),
                  Text('Tanggal: ${formatTanggal(booking.createdAt)}'),
                  if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Catatan: ${booking.notes}'),
                  ],
                  const SizedBox(height: 12),
                  Text(formatRupiah(booking.price), style: const TextStyle(fontSize: 18, color: AppColors.kuningLogo, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status Timeline
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status Pekerjaan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
                  const SizedBox(height: 12),
                  _buildStatusStep('Menunggu', 'pending', booking.status),
                  _buildStatusStep('Diterima', 'accepted', booking.status),
                  _buildStatusStep('Dikerjakan', 'in_progress', booking.status),
                  _buildStatusStep('Selesai', 'completed', booking.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Review section for completed bookings
          if (booking.status == 'completed' && booking.reviewRating == null)
            ElevatedButton.icon(
              onPressed: () => _showRatingDialog(context),
              icon: const Icon(Icons.star, color: AppColors.biruNavy),
              label: const Text('Beri Rating & Review', style: TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kuningLogo,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

          // Show existing review
          if (booking.reviewRating != null)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Review Anda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < (booking.reviewRating ?? 0).round() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      )),
                    ),
                    if (booking.reviewText != null) ...[
                      const SizedBox(height: 4),
                      Text(booking.reviewText!),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.blue;
      case 'in_progress': return AppColors.biruNavy;
      case 'completed': return AppColors.hijauSukses;
      case 'rejected': return Colors.red;
      case 'cancelled': return Colors.grey;
      default: return Colors.grey;
    }
  }

  Widget _buildStatusStep(String label, String stepStatus, String currentStatus) {
    final statusOrder = ['pending', 'accepted', 'in_progress', 'completed'];
    final currentIndex = statusOrder.indexOf(currentStatus);
    final stepIndex = statusOrder.indexOf(stepStatus);
    final isActive = stepIndex <= currentIndex && currentIndex >= 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.hijauSukses : Colors.grey.shade300,
            ),
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black87 : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Beri Rating & Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => IconButton(
                  icon: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setDialogState(() => _rating = i + 1.0);
                  },
                )),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tulis review Anda...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_rating > 0) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Review berhasil dikirim!'), backgroundColor: Colors.green),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.biruNavy),
              child: const Text('Kirim', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
