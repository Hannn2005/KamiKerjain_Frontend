import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class PaymentScreen extends StatefulWidget {
  final BookingModel booking;

  const PaymentScreen({Key? key, required this.booking}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod = 'Transfer Bank';
  final double adminFee = 5000;

  void _processPayment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.kuningLogo)),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context); // close loading
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pembayaran Berhasil'),
          content: const Text('Booking Anda telah dikonfirmasi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Ke Beranda', style: TextStyle(color: AppColors.biruNavy)),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.booking.price + adminFee;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
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
                  const Text('Ringkasan Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(widget.booking.jasaTitle),
                    trailing: Text(formatRupiah(widget.booking.price)),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Biaya Admin'),
                    trailing: Text(formatRupiah(adminFee)),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(formatRupiah(total), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.kuningLogo, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Pilih Metode Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildPaymentMethod('Transfer Bank', Icons.account_balance),
          _buildPaymentMethod('E-Wallet', Icons.account_balance_wallet),
          _buildPaymentMethod('QRIS', Icons.qr_code),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.biruNavy,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(icon, color: AppColors.biruNavy),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        value: title,
        groupValue: _selectedMethod,
        activeColor: AppColors.kuningLogo,
        onChanged: (value) {
          setState(() {
            _selectedMethod = value;
          });
        },
      ),
    );
  }
}
