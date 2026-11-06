import 'package:flutter/material.dart';
import 'package:kami_kerjain/models/jasa_model.dart';
import 'package:kami_kerjain/services/auth_service.dart';
import 'package:kami_kerjain/services/jasa_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadJasa();
  }

  void _loadJasa() {
    final user = _authService.user;
    if (user != null) {
      setState(() {
        myJasa = _jasaService.getJasaByPenyedia(user.id);
      });
    }
  }

  void _confirmDelete(JasaModel jasa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jasa'),
        content: Text('Yakin ingin menghapus jasa "${jasa.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.abuText)),
          ),
          TextButton(
            onPressed: () {
              _jasaService.deleteJasa(jasa.id);
              Navigator.pop(context);
              _loadJasa();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Jasa berhasil dihapus')),
              );
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
      body: myJasa.isEmpty
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
                                Text(formatRupiah(jasa.price), style: const TextStyle(color: AppColors.hijauSukses, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Switch(
                                value: jasa.isActive,
                                activeColor: AppColors.kuningLogo,
                                onChanged: (value) {
                                  _jasaService.updateJasa(jasa.copyWith(isActive: value));
                                  _loadJasa();
                                },
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
