import 'package:flutter/material.dart';
import 'package:kami_kerjain/models/jasa_model.dart';
import 'package:kami_kerjain/services/auth_service.dart';
import 'package:kami_kerjain/services/jasa_service.dart';
import 'package:kami_kerjain/services/booking_service.dart';
import 'package:kami_kerjain/services/api_client.dart';
import 'package:kami_kerjain/utils/colors.dart';
import 'package:kami_kerjain/utils/helpers.dart';
import 'package:kami_kerjain/screens/penyedia/tambah_jasa_screen.dart';

class KelolaJasaScreen extends StatefulWidget {
  const KelolaJasaScreen({Key? key}) : super(key: key);

  @override
  _KelolaJasaScreenState createState() => _KelolaJasaScreenState();
}

class _KelolaJasaScreenState extends State<KelolaJasaScreen> {
  final JasaService _jasaService = JasaService();
  final AuthService _authService = AuthService();
  List<JasaModel> myJasa = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadJasa();
  }

  Future<void> _loadJasa() async {
    final user = _authService.user;
    if (user == null) return;
    setState(() {
      _isLoading = myJasa.isEmpty;
      _error = null;
    });
    try {
      final list = await _jasaService.getJasaByPenyedia(user.id);
      if (!mounted) return;
      setState(() {
        myJasa = list;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleActive(JasaModel jasa, bool value) async {
    try {
      await _jasaService.setActive(jasa.id, value);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.merahError),
      );
    }
    if (mounted) _loadJasa();
  }

  Future<void> _confirmDelete(JasaModel jasa) async {
    // Jasa yang masih punya pesanan berjalan tidak boleh dihapus
    bool hasActive = false;
    try {
      hasActive = await BookingService().hasActiveBookingForJasa(jasa.id);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.merahError),
      );
      return;
    }
    if (!mounted) return;

    if (hasActive) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Jasa Tidak Dapat Dihapus'),
          content: Text(
            'Jasa "${jasa.title}" masih memiliki pesanan yang sedang berjalan. '
            'Selesaikan atau tolak pesanan tersebut terlebih dahulu.\n\n'
            'Jika hanya ingin menyembunyikannya, nonaktifkan jasa dengan switch.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mengerti', style: TextStyle(color: AppColors.biruNavy)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jasa'),
        content: Text('Yakin ingin menghapus jasa "${jasa.title}"? Jasa akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.abuText)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final messenger = ScaffoldMessenger.of(this.context);
              try {
                await _jasaService.deleteJasa(jasa.id);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Jasa berhasil dihapus')),
                );
              } on ApiException catch (e) {
                // Jasa yang sudah punya riwayat pesanan ditolak database (FK RESTRICT).
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(e.statusCode == 500
                        ? 'Jasa tidak dapat dihapus karena sudah memiliki riwayat pesanan. Nonaktifkan saja jasa ini.'
                        : e.message),
                    backgroundColor: AppColors.merahError,
                  ),
                );
              }
              if (mounted) _loadJasa();
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.merahError)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        title: const Text('Kelola Jasa Saya', style: TextStyle(color: AppColors.putih)),
        backgroundColor: AppColors.biruNavy,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _loadJasa, child: const Text('Coba lagi')),
                ],
              ),
            )
          : myJasa.isEmpty
          ? const Center(
              child: Text('Belum ada jasa terdaftar', style: TextStyle(color: AppColors.abuText, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myJasa.length,
              itemBuilder: (context, index) {
                final jasa = myJasa[index];
                return Dismissible(
                  key: Key(jasa.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    _confirmDelete(jasa);
                    return false;
                  },
                  background: Container(
                    color: AppColors.merahError,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: AppColors.putih),
                  ),
                  child: Card(
                    color: AppColors.putih,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(jasa.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(jasa.category, style: const TextStyle(color: AppColors.abuText)),
                                const SizedBox(height: 4),
                                Text('${jasa.formattedPriceType} ${formatRupiah(jasa.price)} ${jasa.priceUnit}', style: const TextStyle(color: AppColors.hijauSukses, fontWeight: FontWeight.bold, fontSize: 13)),
                                if (jasa.options.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text('${jasa.options.length} Opsi Tambahan Terdaftar', style: const TextStyle(color: AppColors.biruNavy, fontSize: 11, fontWeight: FontWeight.w600)),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Switch(
                                value: jasa.isActive,
                                activeColor: AppColors.kuningLogo,
                                onChanged: (value) => _toggleActive(jasa, value),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.merahError),
                                tooltip: 'Hapus jasa',
                                onPressed: () => _confirmDelete(jasa),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.biruNavy),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TambahJasaScreen(jasaToEdit: jasa)),
                                  );
                                  _loadJasa();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahJasaScreen()),
          );
          _loadJasa();
        },
        backgroundColor: AppColors.kuningLogo,
        child: const Icon(Icons.add, color: AppColors.biruNavy),
      ),
    );
  }
}
