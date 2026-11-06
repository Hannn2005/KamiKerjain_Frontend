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
      description: 'Membantu mengerjakan tugas kuliah dan sekolah dengan cepat, rapi, dan bergaransi.',
      category: 'Tugas & Akademik',
      price: 50000.0,
      priceType: 'starting_from',
      priceUnit: '/ tugas',
      options: [
        JasaOption(id: 'opt_1_1', title: 'Pengerjaan Kilat (< 12 Jam)', price: 30000.0),
        JasaOption(id: 'opt_1_2', title: 'Cek Turnitin & Parafrase Anti Plagiasi', price: 25000.0),
        JasaOption(id: 'opt_1_3', title: 'Revisi Tanpa Batas (Maks 7 Hari)', price: 20000.0),
      ],
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
      description: 'Pembuatan logo profesional, modern, dan berkarakter untuk bisnis dan komunitas.',
      category: 'Desain & Multimedia',
      price: 150000.0,
      priceType: 'starting_from',
      priceUnit: '/ konsep dasar',
      options: [
        JasaOption(id: 'opt_2_1', title: 'Master File Lengkap (AI, EPS, SVG, PNG High Res)', price: 50000.0),
        JasaOption(id: 'opt_2_2', title: 'Brand Guidelines Mini + Mockup 3D', price: 75000.0),
        JasaOption(id: 'opt_2_3', title: 'Desain Kartu Nama & Kop Surat', price: 60000.0),
      ],
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
      description: 'Edit video kreatif untuk YouTube, Instagram Reels, TikTok, dan video profil bisnis.',
      category: 'Desain & Multimedia',
      price: 200000.0,
      priceType: 'starting_from',
      priceUnit: '/ menit pertama',
      options: [
        JasaOption(id: 'opt_3_1', title: 'Tambah Durasi (+1 Menit)', price: 100000.0),
        JasaOption(id: 'opt_3_2', title: 'Efek Sound Design & Musik Bebas Copyright', price: 40000.0),
        JasaOption(id: 'opt_3_3', title: 'Subtitle Lengkap & Caption Animasi', price: 50000.0),
      ],
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
      description: 'Pembuatan website profesional (Landing page, Company Profile, Toko Online) responsif mobile.',
      category: 'Teknologi & IT',
      price: 1500000.0,
      priceType: 'starting_from',
      priceUnit: '/ paket dasar (1-3 hal)',
      options: [
        JasaOption(id: 'opt_4_1', title: 'Tambah 1 Halaman Web Tambahan', price: 150000.0),
        JasaOption(id: 'opt_4_2', title: 'Integrasi Payment Gateway (Midtrans/Xendit)', price: 350000.0),
        JasaOption(id: 'opt_4_3', title: 'Setup Domain & Hosting 1 Tahun', price: 300000.0),
        JasaOption(id: 'opt_4_4', title: 'Pengerjaan Express (Selesai 3 Hari)', price: 250000.0),
      ],
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
      description: 'Bimbingan belajar matematika intensif untuk SD, SMP, SMA secara privat atau kelompok.',
      category: 'Les & Bimbingan',
      price: 75000.0,
      priceType: 'hourly',
      priceUnit: '/ sesi (90 menit)',
      options: [
        JasaOption(id: 'opt_5_1', title: 'Modul Latihan Soal & Pembahasan Lengkap', price: 25000.0),
        JasaOption(id: 'opt_5_2', title: 'Sesi Tambahan Tanya Jawab (+45 Menit)', price: 40000.0),
      ],
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
      description: 'Pembersihan rumah, kos, atau apartemen menyeluruh dengan peralatan higienis dan profesional.',
      category: 'Jasa Rumah Tangga',
      price: 100000.0,
      priceType: 'starting_from',
      priceUnit: '/ 2 jam standar',
      options: [
        JasaOption(id: 'opt_6_1', title: 'Deep Cleaning Kamar Mandi Berkerak', price: 60000.0),
        JasaOption(id: 'opt_6_2', title: 'Hydro Vacuum Kasur & Sofa Anti Tungau', price: 80000.0),
        JasaOption(id: 'opt_6_3', title: 'Setrika & Lipat Pakaian (Maks 5kg)', price: 40000.0),
      ],
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
      description: 'Penulisan artikel SEO friendly untuk blog, website, dan portal berita.',
      category: 'Penulisan & Konten',
      price: 35000.0,
      priceType: 'starting_from',
      priceUnit: '/ 500 kata',
      options: [
        JasaOption(id: 'opt_7_1', title: 'Tambah 500 Kata (+500 kata)', price: 30000.0),
        JasaOption(id: 'opt_7_2', title: 'Riset Kata Kunci / Keyword Research', price: 20000.0),
        JasaOption(id: 'opt_7_3', title: 'Posting Langsung ke WordPress + Gambar', price: 15000.0),
      ],
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
      description: 'Input data Excel atau database akurat, rapi, dan cepat dengan kerahasiaan terjamin.',
      category: 'Lainnya',
      price: 50000.0,
      priceType: 'starting_from',
      priceUnit: '/ 100 baris data',
      options: [
        JasaOption(id: 'opt_8_1', title: 'Pembersihan & Validasi Data Duplikat', price: 25000.0),
        JasaOption(id: 'opt_8_2', title: 'Pengerjaan Kilat Same Day', price: 30000.0),
      ],
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
      description: 'Dokumentasi acara pernikahan, wisuda, produk katalog, dan photoshoot studio.',
      category: 'Desain & Multimedia',
      price: 500000.0,
      priceType: 'starting_from',
      priceUnit: '/ sesi 2 jam',
      options: [
        JasaOption(id: 'opt_9_1', title: 'Ekstra Waktu (+1 Jam)', price: 150000.0),
        JasaOption(id: 'opt_9_2', title: 'Color Grading & Retouch 20 Foto Pilihan', price: 100000.0),
        JasaOption(id: 'opt_9_3', title: 'Cetak Album Foto Eksklusif 20 Hal', price: 250000.0),
      ],
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
      description: 'Penerjemah tersumpah dokumen bahasa Indonesia - Inggris - Mandarin.',
      category: 'Penulisan & Konten',
      price: 50000.0,
      priceType: 'starting_from',
      priceUnit: '/ lembar tersumpah',
      options: [
        JasaOption(id: 'opt_10_1', title: 'Pengerjaan Prioritas 24 Jam', price: 35000.0),
        JasaOption(id: 'opt_10_2', title: 'Legalisasi Dokumen Tambahan', price: 50000.0),
      ],
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
