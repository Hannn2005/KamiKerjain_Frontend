import 'package:flutter/material.dart';
import 'package:kami_kerjain/models/jasa_model.dart';
import 'package:kami_kerjain/services/auth_service.dart';
import 'package:kami_kerjain/services/jasa_service.dart';
import 'package:kami_kerjain/utils/colors.dart';

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
  final _locationController = TextEditingController();
  
  String? _selectedCategory;
  
  final List<String> _categories = [
    'Tugas & Akademik',
    'Desain & Multimedia',
    'Teknologi & IT',
    'Penulisan & Konten',
    'Jasa Rumah Tangga',
    'Les & Bimbingan',
    'Lainnya'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.jasaToEdit != null) {
      _titleController.text = widget.jasaToEdit!.title;
      _descriptionController.text = widget.jasaToEdit!.description;
      _priceController.text = widget.jasaToEdit!.price.toInt().toString();
      _locationController.text = widget.jasaToEdit!.location;
      _selectedCategory = widget.jasaToEdit!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
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
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory!,
        price: double.parse(_priceController.text),
        location: _locationController.text,
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
                  // Simulate image upload
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulasi upload gambar')));
                },
                child: Container(
                  height: 150,
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
                      Text('Upload Foto Jasa', style: TextStyle(color: AppColors.biruNavy)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Jasa', border: OutlineInputBorder()),
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
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga (Rp)', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Harga tidak boleh kosong' : null,
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
