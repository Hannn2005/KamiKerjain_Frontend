import '../models/jasa_model.dart';

class JasaService {
  static final JasaService _instance = JasaService._internal();
  factory JasaService() => _instance;
  JasaService._internal();

  final String _uuid = DateTime.now().millisecondsSinceEpoch.toString();

  final List<JasaModel> _allJasa = [
    JasaModel(
      id: 'jasa_1',
      penyediaId: 'usr_2',
      penyediaName: 'Budi Freelancer',
      title: 'Jasa Kerjain Tugas',
      description: 'Membantu mengerjakan tugas kuliah dan sekolah dengan cepat.',
      category: 'Tugas & Akademik',
      price: 50000.0,
      location: 'Online',
      rating: 4.8,
      totalReviews: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    JasaModel(
      id: 'jasa_2',
      penyediaId: 'usr_3',
      penyediaName: 'Siti Designer',
      title: 'Jasa Desain Logo',
      description: 'Pembuatan logo profesional untuk bisnis dan komunitas.',
      category: 'Desain & Multimedia',
      price: 150000.0,
      location: 'Jakarta',
      rating: 4.9,
      totalReviews: 24,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    JasaModel(
      id: 'jasa_3',
      penyediaId: 'usr_3',
      penyediaName: 'Siti Designer',
      title: 'Jasa Edit Video',
      description: 'Edit video untuk YouTube, Instagram Reels, dan TikTok.',
      category: 'Desain & Multimedia',
      price: 200000.0,
      location: 'Bandung',
      rating: 4.7,
      totalReviews: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    JasaModel(
      id: 'jasa_4',
      penyediaId: 'usr_2',
      penyediaName: 'Budi Freelancer',
      title: 'Jasa Buat Website',
      description: 'Pembuatan website company profile dan toko online menggunakan WordPress.',
      category: 'Teknologi & IT',
      price: 1500000.0,
      location: 'Surabaya',
      rating: 5.0,
      totalReviews: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    JasaModel(
      id: 'jasa_5',
      penyediaId: 'usr_2',
      penyediaName: 'Budi Freelancer',
      title: 'Les Matematika',
      description: 'Bimbingan belajar matematika untuk SD, SMP, SMA.',
      category: 'Les & Bimbingan',
      price: 75000.0,
      location: 'Malang',
      rating: 4.5,
      totalReviews: 18,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
    JasaModel(
      id: 'jasa_6',
      penyediaId: 'usr_3',
      penyediaName: 'Siti Designer',
      title: 'Jasa Cleaning Service',
      description: 'Pembersihan rumah, kos, atau apartemen menyeluruh.',
      category: 'Jasa Rumah Tangga',
      price: 100000.0,
      location: 'Jakarta Selatan',
      rating: 4.6,
      totalReviews: 30,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
    JasaModel(
      id: 'jasa_7',
      penyediaId: 'usr_2',
      penyediaName: 'Budi Freelancer',
      title: 'Jasa Penulisan Artikel',
      description: 'Penulisan artikel SEO untuk blog dan website.',
      category: 'Penulisan & Konten',
      price: 35000.0,
      location: 'Online',
      rating: 4.8,
      totalReviews: 42,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    JasaModel(
      id: 'jasa_8',
      penyediaId: 'usr_2',
      penyediaName: 'Budi Freelancer',
      title: 'Jasa Input Data',
      description: 'Input data Excel atau database akurat dan cepat.',
      category: 'Lainnya',
      price: 50000.0,
      location: 'Online',
      rating: 4.4,
      totalReviews: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    JasaModel(
      id: 'jasa_9',
      penyediaId: 'usr_3',
      penyediaName: 'Siti Designer',
      title: 'Jasa Fotografi',
      description: 'Dokumentasi acara pernikahan, ulang tahun, dan produk.',
      category: 'Desain & Multimedia',
      price: 500000.0,
      location: 'Depok',
      rating: 4.9,
      totalReviews: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
    ),
    JasaModel(
      id: 'jasa_10',
      penyediaId: 'usr_2',
      penyediaName: 'Budi Freelancer',
      title: 'Jasa Translate',
      description: 'Penerjemah dokumen dari Bahasa Indonesia ke Bahasa Inggris dan sebaliknya.',
      category: 'Penulisan & Konten',
      price: 50000.0,
      location: 'Online',
      rating: 4.7,
      totalReviews: 22,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
  ];

  List<JasaModel> getAllJasa() {
    return _allJasa.where((jasa) => jasa.isActive).toList();
  }

  List<JasaModel> searchJasa(String query) {
    return _allJasa.where((jasa) {
      return jasa.isActive && 
             (jasa.title.toLowerCase().contains(query.toLowerCase()) || 
              jasa.description.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  List<JasaModel> filterByCategory(String category) {
    return _allJasa.where((jasa) => jasa.isActive && jasa.category == category).toList();
  }

  JasaModel? getJasaById(String id) {
    try {
      return _allJasa.firstWhere((jasa) => jasa.id == id);
    } catch (e) {
      return null;
    }
  }

  List<JasaModel> getJasaByPenyedia(String penyediaId) {
    return _allJasa.where((jasa) => jasa.penyediaId == penyediaId).toList();
  }

  void addJasa(JasaModel jasa) {
    final newJasa = jasa.copyWith(id: _uuid, createdAt: DateTime.now());
    _allJasa.add(newJasa);
  }

  void updateJasa(JasaModel jasa) {
    final index = _allJasa.indexWhere((j) => j.id == jasa.id);
    if (index != -1) {
      _allJasa[index] = jasa;
    }
  }

  void deleteJasa(String id) {
    // Soft delete / disable
    final index = _allJasa.indexWhere((j) => j.id == id);
    if (index != -1) {
      _allJasa[index] = _allJasa[index].copyWith(isActive: false);
    }
  }
}
