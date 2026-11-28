import 'package:flutter/material.dart';
import '../models/jasa_model.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../services/api_client.dart';
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

  // Selected add-on options
  final Set<String> _selectedOptionIds = {};
  bool _isSubmitting = false;

  double get _addonsTotal {
    double sum = 0.0;
    for (var opt in widget.jasa.options) {
      if (_selectedOptionIds.contains(opt.id)) {
        sum += opt.price;
      }
    }
    return sum;
  }

  double get _totalPrice => widget.jasa.price + _addonsTotal;

  List<JasaOption> get _selectedOptions =>
      widget.jasa.options.where((o) => _selectedOptionIds.contains(o.id)).toList();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

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

  Future<void> _confirmBooking() async {
    if (_isSubmitting) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tanggal pengerjaan terlebih dahulu!')));
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    // Backend belum punya kolom tanggal pengerjaan, jadi tanggal disimpan di catatan.
    final userNotes = _notesController.text.trim();
    final notes = 'Tanggal pengerjaan: ${formatTanggal(_selectedDate!)}'
        '${userNotes.isNotEmpty ? '\n$userNotes' : ''}';

    setState(() => _isSubmitting = true);
    final BookingModel savedBooking;
    try {
      savedBooking = await BookingService().createBooking(
        jasaId: widget.jasa.id,
        selectedOptions: _selectedOptions,
        notes: notes,
        priceNote: widget.jasa.formattedPriceType,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
      return;
    }
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Dikonfirmasi', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
        content: Text(
          'Total estimasi pesanan Anda adalah ${formatRupiah(savedBooking.price)}.\nSilakan lanjutkan ke proses pembayaran.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PaymentScreen(booking: savedBooking)),
              );
            },
            child: const Text('Lanjut Pembayaran', style: TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        title: const Text('Kustomisasi & Booking Jasa', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.biruNavy,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Service Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Detail Jasa', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.biruMuda,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(widget.jasa.formattedPriceType, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.jasa.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Penyedia: ${widget.jasa.penyediaName}', style: const TextStyle(color: AppColors.abuText)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(formatRupiah(widget.jasa.price), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.kuningLogo)),
                        const SizedBox(width: 4),
                        Text(widget.jasa.priceUnit, style: const TextStyle(color: AppColors.abuText, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dynamic Options / Add-ons Selector Card
            if (widget.jasa.options.isNotEmpty) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune, color: AppColors.biruNavy, size: 20),
                          SizedBox(width: 8),
                          Text('Pilih Layanan Tambahan (Add-ons)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('Sesuaikan pekerjaan sesuai kebutuhan spesifik Anda:', style: TextStyle(fontSize: 12, color: AppColors.abuText)),
                      const SizedBox(height: 8),
                      const Divider(),
                      ...widget.jasa.options.map((opt) {
                        final isSelected = _selectedOptionIds.contains(opt.id);
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(opt.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          subtitle: Text('+ ${formatRupiah(opt.price)}', style: const TextStyle(color: AppColors.hijauSukses, fontWeight: FontWeight.bold)),
                          value: isSelected,
                          activeColor: AppColors.biruNavy,
                          onChanged: (bool? val) {
                            setState(() {
                              if (val == true) {
                                _selectedOptionIds.add(opt.id);
                              } else {
                                _selectedOptionIds.remove(opt.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Date picker card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  _selectedDate == null ? 'Pilih Tanggal Pengerjaan' : 'Tanggal: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontWeight: _selectedDate != null ? FontWeight.bold : FontWeight.normal),
                ),
                trailing: const Icon(Icons.calendar_today, color: AppColors.biruNavy),
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: 16),

            // Notes field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Catatan Spesifikasi / Kondisi Khusus (Opsional)',
                hintText: 'Contoh: Rumah tipe 45, ada noda membandel di kamar mandi...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Live Price Calculation Card
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rincian Estimasi Biaya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Dasar (${widget.jasa.priceUnit})', style: const TextStyle(color: AppColors.abuText)),
                        Text(formatRupiah(widget.jasa.price)),
                      ],
                    ),
                    if (_addonsTotal > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Layanan Tambahan (${_selectedOptionIds.length} item)', style: const TextStyle(color: AppColors.abuText)),
                          Text('+ ${formatRupiah(_addonsTotal)}', style: const TextStyle(color: AppColors.hijauSukses)),
                        ],
                      ),
                    ],
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Estimasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(formatRupiah(_totalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.kuningLogo)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.abuMuda,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: AppColors.abuText),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Harga dapat disesuaikan kembali dengan penyedia jika terdapat revisi atau kondisi aktual di lapangan.',
                              style: TextStyle(fontSize: 11, color: AppColors.abuText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.biruNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Konfirmasi & Lanjut Pembayaran', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
