import 'dart:typed_data';

import '../models/user_model.dart';
import 'api_client.dart';


class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiClient _api = ApiClient();

  UserModel? currentUser;

  bool get isLoggedIn => currentUser != null;
  UserModel? get user => currentUser;

  // ------------------------------------------------------------- sesi/akun

  /// Login. Melempar [ApiException] jika gagal (mis. email/password salah).
  Future<UserModel> login(String email, String password) async {
    final res = await _api.post('/auth/login', body: {
      'email': email.trim(),
      'password': password,
    });
    final user = UserModel.fromMap(res['data'] as Map<String, dynamic>);
    currentUser = user;
    return user;
  }

  /// Daftar sebagai customer.
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    await _api.post('/auth/register', body: {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'role': 'customer',
    });
  }

  /// Daftar sebagai penyedia jasa (status awal `pending` sampai disetujui admin).
  Future<void> registerPenyedia({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String category,
    required String portfolioText,
    required String cvFileName,
    Uint8List? cvBytes,
  }) async {
    await _api.multipart(
      'POST',
      '/auth/register',
      fields: {
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
        'role': 'penyedia',
        'category': category,
        'portfolioText': portfolioText,
        'cvFileName': cvFileName,
      },
      files: cvBytes == null
          ? const []
          : [UploadFile(field: 'cvFile', bytes: cvBytes, filename: cvFileName)],
    );
  }

  /// Ambil ulang data user dari server. Mengembalikan null jika belum login.
  Future<UserModel?> refreshCurrentUser() async {
    try {
      final res = await _api.get('/auth/me');
      currentUser = UserModel.fromMap(res['data'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      if (e.statusCode == 401) currentUser = null;
      rethrow;
    }
    return currentUser;
  }

  /// Logout. State lokal selalu dibersihkan walaupun request gagal.
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {
      // Abaikan: sesi lokal tetap dibuang.
    } finally {
      currentUser = null;
      _api.clearSession();
    }
  }

  Future<UserModel> updateProfile({
    String? username,
    String? phone,
    String? address,
    String? description,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final fields = <String, String>{};
    if (username != null) fields['username'] = username;
    if (phone != null) fields['phone'] = phone;
    if (address != null) fields['address'] = address;
    if (description != null) fields['description'] = description;

    final res = await _api.multipart(
      'PATCH',
      '/auth/profile',
      fields: fields,
      files: imageBytes == null
          ? const []
          : [
              UploadFile(
                field: 'profileImage',
                bytes: imageBytes,
                filename: imageName ?? 'profile.jpg',
              )
            ],
    );
    final updated = UserModel.fromMap(res['data'] as Map<String, dynamic>);
    currentUser = updated;
    return updated;
  }

  // ----------------------------------------------------------------- admin

  Future<List<UserModel>> getAllUsers() async {
    final res = await _api.get('/auth/users');
    return _parseUsers(res['data']);
  }

  Future<List<UserModel>> getProviders({String? status}) async {
    final res = await _api.get('/auth/providers', query: {'status': status});
    return _parseUsers(res['data']);
  }

  Future<UserModel> approveProvider(String userId) async {
    final res = await _api.patch('/auth/providers/$userId/approve');
    return UserModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<UserModel> rejectProvider(String userId, String reason) async {
    final res = await _api
        .patch('/auth/providers/$userId/reject', body: {'reason': reason});
    return UserModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<void> deleteUser(String userId) async {
    await _api.delete('/auth/users/$userId');
  }

  List<UserModel> _parseUsers(dynamic data) {
    final list = (data as List?) ?? const [];
    return list
        .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
