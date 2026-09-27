import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? currentUser;
  final String _uuid = DateTime.now().millisecondsSinceEpoch.toString();

  final List<UserModel> _users = [
    UserModel(
      id: 'usr_1',
      username: 'Ahmad',
      email: 'customer@test.com',
      phone: '081234567890',
      role: 'customer',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserModel(
      id: 'usr_2',
      username: 'Budi Freelancer',
      email: 'penyedia@test.com',
      phone: '081298765432',
      role: 'penyedia',
      description: 'Penyedia jasa serba bisa',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    UserModel(
      id: 'usr_3',
      username: 'Siti Designer',
      email: 'penyedia2@test.com',
      phone: '081345678901',
      role: 'penyedia',
      description: 'Desainer grafis profesional',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
  ];
  
  // A simple password map for our mock service (in real app, use secure authentication)
  final Map<String, String> _userPasswords = {
    'customer@test.com': '123456',
    'penyedia@test.com': '123456',
    'penyedia2@test.com': '123456',
  };

  Future<bool> login(String email, String password) async {
    // Simulate network delay
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

  Future<bool> register(String username, String email, String password, String phone, String role) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check if email already exists
    if (_users.any((u) => u.email == email)) {
      return false; 
    }

    final newUser = UserModel(
      id: _uuid,
      username: username,
      email: email,
      phone: phone,
      role: role,
      createdAt: DateTime.now(),
    );

    _users.add(newUser);
    _userPasswords[email] = password;
    
    return true;
  }

  void logout() {
    currentUser = null;
  }

  bool get isLoggedIn => currentUser != null;
  
  UserModel? get user => currentUser;
}
