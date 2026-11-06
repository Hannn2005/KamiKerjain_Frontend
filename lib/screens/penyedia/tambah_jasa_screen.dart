import 'package:flutter/material.dart';
import 'package:kami_kerjain/models/jasa_model.dart';
import 'package:kami_kerjain/services/auth_service.dart';
import 'package:kami_kerjain/services/jasa_service.dart';
import 'package:kami_kerjain/utils/colors.dart';
import 'package:kami_kerjain/utils/helpers.dart';

class TambahJasaScreen extends StatefulWidget {
  final JasaModel? jasaToEdit;

  const TambahJasaScreen({Key? key, this.jasaToEdit}) : super(key: key);

  @override
  _TambahJasaScreenState createState() => _TambahJasaScreenState();
}

class _TambahJasaScreenState extends State<TambahJasaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _priceUnitController = TextEditingController(text: '/ proyek');
  final _locationController = TextEditingController();
  
  String? _selectedCategory;
  String _selectedPriceType = 'starting_from'; // 'starting_from', 'hourly', 'fixed', 'survey'
  List<JasaOption> _options = [];
  
  final List<String> _categories = [
    'Tugas & Akademik',
    'Desain & Multimedia',
    'Teknologi & IT',
    'Penulisan & Konten',
    'Jasa Rumah Tangga',
    'Les & Bimbingan',
    'Lainnya'
  ];

  final Map<String, String> _priceTypeLabels = {
    'starting_from': 'Mulai Dari (Harga Dinamis / Estimasi Awal)',
    'hourly': 'Tarif per Jam / Waktu Kerja',
    'fixed': 'Harga Pas (Paket Tetap)',
    'survey': 'Perlu Survei Lapangan Dahulu',
  };

  @override
  void initState() {
    super.initState();
    if (widget.jasaToEdit != null) {
      _titleController.text = widget.jasaToEdit!.title;
      _descriptionController.text = widget.jasaToEdit!.description;
      _priceController.text = widget.jasaToEdit!.price.toInt().toString();
      _priceUnitController.text = widget.jasaToEdit!.priceUnit;
      _locationController.text = widget.jasaToEdit!.location;
      _selectedCategory = widget.jasaToEdit!.category;
      _selectedPriceType = widget.jasaToEdit!.priceType;
      _options = List.from(widget.jasaToEdit!.options);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _priceUnitController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showAddOptionDialog({JasaOption? optionToEdit, int? editIndex}) {
    final titleController = TextEditingController(text: optionToEdit?.title ?? '');
    final priceController = TextEditingController(
      text: optionToEdit != null ? optionToEdit.price.toInt().toString() : '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          optionToEdit == null ? 'Tambah Layanan Tambahan' : 'Edit Layanan Tambahan',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.biruNavy),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Opsi / Add-on',
                  hintText: 'misal: Pengerjaan Kilat 24 Jam',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Nama opsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Biaya Tambahan (Rp)',
                  hintText: 'misal: 50000',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Biaya wajib diisi';
                  if (double.tryParse(val) == null) return 'Masukkan angka valid';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.abuText)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final double price = double.parse(priceController.text);
                setState(() {
                  if (editIndex != null) {
                    _options[editIndex] = JasaOption(
                      id: optionToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      price: price,
                    );
                  } else {
                    _options.add(JasaOption(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      price: price,
                    ));
                  }
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.biruNavy),
            child: const Text('Simpan', style: TextStyle(color: AppColors.putih)),
          ),
        ],
      ),
    );
  }

  void _saveJasa() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih kategori jasa')));
        return;
      }
      
      final user = AuthService().user;
      if (user == null) return;
      
      final newJasa = JasaModel(
        id: widget.jasaToEdit?.id ?? '', // Empty string for new, JasaService will generate uuid
        penyediaId: user.id,
        penyediaName: user.username,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        price: double.parse(_priceController.text),
        priceType: _selectedPriceType,
        priceUnit: _priceUnitController.text.trim().isNotEmpty ? _priceUnitController.text.trim() : '/ proyek',
        options: _options,
        location: _locationController.text.trim(),
        isActive: widget.jasaToEdit?.isActive ?? true,
        createdAt: widget.jasaToEdit?.createdAt ?? DateTime.now(),
      );

      if (widget.jasaToEdit != null) {
        JasaService().updateJasa(newJasa);
      } else {
        JasaService().addJasa(newJasa);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.jasaToEdit != null ? 'Jasa berhasil diperbarui' : 'Jasa berhasil ditambahkan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        title: Text(widget.jasaToEdit != null ? 'Edit Jasa' : 'Tambah Jasa', style: const TextStyle(color: AppColors.putih)),
        backgroundColor: AppColors.biruNavy,
        iconTheme: const IconThemeData(color: AppColors.putih),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulasi upload gambar')));
                },
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.biruMuda,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.biruNavy.withOpacity(0.3)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: AppColors.biruNavy),
                      SizedBox(height: 8),
                      Text('Upload Foto Layanan', style: TextStyle(color: AppColors.biruNavy, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Jasa',
                  hintText: 'misal: Jasa Pembuatan Website / Jasa Bersih Rumah',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (val) => val == null ? 'Pilih kategori' : null,
              ),
              const SizedBox(height: 16),
              
              // Pricing Section Card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.monetization_on, color: AppColors.biruNavy),
                          SizedBox(width: 8),
                          Text('Pengaturan Model Tarif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.biruNavy)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pilih skema tarif agar calon klien paham apakah harga bersifat estimasi, per jam, atau fixed.',
                        style: TextStyle(fontSize: 12, color: AppColors.abuText),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _selectedPriceType,
                        decoration: const InputDecoration(labelText: 'Tipe Skema Harga', border: OutlineInputBorder()),
                        items: _priceTypeLabels.entries.map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value, style: const TextStyle(fontSize: 13)),
                        )).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedPriceType = val;
                              if (val == 'hourly') {
                                _priceUnitController.text = '/ jam';
                              } else if (val == 'survey') {
                                _priceUnitController.text = '/ survei';
                              } else {
                                _priceUnitController.text = '/ proyek';
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Harga Dasar (Rp)',
                                hintText: 'misal: 100000',
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Harga tidak boleh kosong' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _priceUnitController,
                              decoration: const InputDecoration(
                                labelText: 'Satuan',
                                hintText: 'misal: / jam',
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Satuan tidak boleh kosong' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Options / Add-ons Section
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Layanan / Opsi Tambahan (Add-ons)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.biruNavy)),
                              Text('Opsi ekstra yang dapat dicentang klien saat booking', style: TextStyle(fontSize: 11, color: AppColors.abuText)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: AppColors.biruNavy, size: 28),
                            onPressed: () => _showAddOptionDialog(),
                            tooltip: 'Tambah Opsi',
                          ),
                        ],
                      ),
                      const Divider(),
                      if (_options.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Belum ada opsi tambahan. Klik tanda (+) di atas untuk menambahkan seperti: Pengerjaan Kilat, Tambah Halaman, dsb.',
                            style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.abuText, fontSize: 12),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _options.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, idx) {
                            final opt = _options[idx];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(opt.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              subtitle: Text('+ ${formatRupiah(opt.price)}', style: const TextStyle(color: AppColors.hijauSukses, fontWeight: FontWeight.bold)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18, color: AppColors.biruNavy),
                                    onPressed: () => _showAddOptionDialog(optionToEdit: opt, editIndex: idx),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.merahError),
                                    onPressed: () {
                                      setState(() {
                                        _options.removeAt(idx);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Lokasi (misal: Online, Jakarta)', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Lokasi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Deskripsi Jasa', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveJasa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kuningLogo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan Jasa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
