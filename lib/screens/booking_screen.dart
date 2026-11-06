import 'package:flutter/material.dart';
import '../models/jasa_model.dart';
import '../models/booking_model.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final JasaModel jasa;

  const BookingScreen({Key? key, required this.jasa}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _notesController = TextEditingController();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final user = AuthService().currentUser;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Berhasil'),
          content: const Text('Silakan lanjutkan ke pembayaran.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                BookingModel tempBooking = BookingModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  jasaId: widget.jasa.id,
                  jasaTitle: widget.jasa.title,
                  customerId: user?.id ?? '',
                  customerName: user?.username ?? '',
                  penyediaId: widget.jasa.penyediaId,
                  penyediaName: widget.jasa.penyediaName,
                  price: widget.jasa.price,
                  status: 'pending',
                  notes: _notesController.text,
                  createdAt: _selectedDate ?? DateTime.now(),
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PaymentScreen(booking: tempBooking)));
              },
              child: const Text('OK', style: TextStyle(color: AppColors.biruNavy)),
            )
          ],
        ),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tanggal booking!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Jasa', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.biruNavy,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail Jasa', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(widget.jasa.title, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Penyedia: ${widget.jasa.penyediaName}', style: const TextStyle(color: AppColors.abuText)),
                    const SizedBox(height: 8),
                    Text(formatRupiah(widget.jasa.price), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.kuningLogo)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_selectedDate == null ? 'Pilih Tanggal Booking' : 'Tanggal: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today, color: AppColors.biruNavy),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: AppColors.abuMuda)),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Catatan (Opsional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.biruNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Konfirmasi Booking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
