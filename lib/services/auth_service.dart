import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? currentUser;
  final String _uuid = DateTime.now().millisecondsSinceEpoch.toString();

  final List<UserModel> _users = [
    // 1. Akun Tetap Admin
    UserModel(
      id: 'usr_admin',
      username: 'Administrator KamiKerjain',
      email: 'admin@kamikerjain.com',
      phone: '081100000001',
      role: 'admin',
      status: 'approved',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    // 2. Akun Customer
    UserModel(
      id: 'usr_1',
      username: 'Ahmad Customer',
      email: 'customer@test.com',
      phone: '081234567890',
      role: 'customer',
      status: 'approved',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    // 3. Akun Penyedia Aktif 1
    UserModel(
      id: 'usr_2',
      username: 'Budi Freelancer',
      email: 'penyedia@test.com',
      phone: '081298765432',
      role: 'penyedia',
      status: 'approved',
      category: 'Teknologi & IT',
      cvFileName: 'CV_Budi_WebDeveloper.pdf',
      portfolioText: 'Fullstack Web Developer, berpengalaman 3 tahun mengerjakan website WordPress, React, dan Flutter.',
      description: 'Penyedia jasa website & IT serba bisa',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    // 4. Akun Penyedia Aktif 2
    UserModel(
      id: 'usr_3',
      username: 'Siti Designer',
      email: 'penyedia2@test.com',
      phone: '081345678901',
      role: 'penyedia',
      status: 'approved',
      category: 'Desain & Multimedia',
      cvFileName: 'Portofolio_Siti_Desain.pdf',
      portfolioText: 'Desainer grafis profesional, mahir Figma, Adobe Illustrator, dan After Effects.',
      description: 'Desainer grafis & video profesional',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    // 5. Akun Calon Penyedia (Menunggu Persetujuan Admin untuk demo)
    UserModel(
      id: 'usr_4',
      username: 'Hendra Servis & Cleaning',
      email: 'calon_mitra@test.com',
      phone: '085711223344',
      role: 'penyedia',
      status: 'pending',
      category: 'Jasa Rumah Tangga',
      cvFileName: 'Sertifikat_Keahlian_Hendra.pdf',
      portfolioText: 'Memiliki sertifikasi BNSP Teknisi Pembersihan & AC. Pengalaman 4 tahun menangani cleaning rumah tinggal dan apartemen.',
      description: 'Spesialis pembersihan rumah & servis peralatan rumah tangga',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
  
  // Password map untuk mock service
  final Map<String, String> _userPasswords = {
    'admin@kamikerjain.com': 'admin123',
    'customer@test.com': '123456',
    'penyedia@test.com': '123456',
    'penyedia2@test.com': '123456',
    'calon_mitra@test.com': '123456',
  };

  Future<bool> login(String email, String password) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_userPasswords[email] == password) {
      try {
        currentUser = _users.firstWhere((user) => user.email == email);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  // Register Customer biasa (langsung approved)
  Future<bool> register(String username, String email, String password, String phone, String role) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_users.any((u) => u.email == email)) {
      return false; 
    }

    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      phone: phone,
      role: role,
      status: role == 'penyedia' ? 'pending' : 'approved',
      createdAt: DateTime.now(),
    );

    _users.add(newUser);
    _userPasswords[email] = password;
    return true;
  }

  // Register Penyedia Jasa khusus (dengan CV, kategori, & portofolio, status 'pending')
  Future<bool> registerPenyedia({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String category,
    required String portfolioText,
    required String cvFileName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (_users.any((u) => u.email == email)) {
      return false;
    }

    final newPenyedia = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      phone: phone,
      role: 'penyedia',
      status: 'pending', // Menunggu persetujuan admin
      category: category,
      portfolioText: portfolioText,
      cvFileName: cvFileName,
      description: portfolioText,
      createdAt: DateTime.now(),
    );

    _users.add(newPenyedia);
    _userPasswords[email] = password;
    return true;
  }

  // Admin Actions:
  List<UserModel> getPendingProviders() {
    return _users.where((u) => u.role == 'penyedia' && u.status == 'pending').toList();
  }

  List<UserModel> getApprovedProviders() {
    return _users.where((u) => u.role == 'penyedia' && u.status == 'approved').toList();
  }

  List<UserModel> getAllUsers() {
    return List.from(_users);
  }

  void approveProvider(String userId) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(status: 'approved');
      if (currentUser?.id == userId) {
        currentUser = _users[idx];
      }
    }
  }

  void rejectProvider(String userId, String reason) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(status: 'rejected', rejectionReason: reason);
      if (currentUser?.id == userId) {
        currentUser = _users[idx];
      }
    }
  }

  void logout() {
    currentUser = null;
  }

  bool get isLoggedIn => currentUser != null;
  
  UserModel? get user => currentUser;
}
