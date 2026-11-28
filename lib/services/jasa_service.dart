import 'dart:convert';
import 'dart:typed_data';

import '../models/jasa_model.dart';
import 'api_client.dart';

/// Katalog jasa lewat REST API (`/api/jasa`).
class JasaService {
  static final JasaService _instance = JasaService._internal();
  factory JasaService() => _instance;
  JasaService._internal();

  final ApiClient _api = ApiClient();

  /// Daftar jasa aktif. Semua filter dikerjakan di server.
  Future<List<JasaModel>> getAllJasa({
    String? query,
    String? category,
    String? penyediaId,
    bool includeInactive = false,
  }) async {
    final res = await _api.get('/jasa', query: {
      'q': (query ?? '').trim(),
      'category': (category == null || category == 'Semua') ? null : category,
      'penyediaId': penyediaId,
      'includeInactive': includeInactive ? 'true' : null,
    });
    return _parseList(res['data']);
  }

  Future<JasaModel> getJasaById(String id) async {
    final res = await _api.get('/jasa/$id');
    return JasaModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  /// Semua jasa milik satu penyedia, termasuk yang dinonaktifkan.
  Future<List<JasaModel>> getJasaByPenyedia(String penyediaId) {
    return getAllJasa(penyediaId: penyediaId, includeInactive: true);
  }

  Future<JasaModel> addJasa(
    JasaModel jasa, {
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final res = await _write('POST', '/jasa', jasa, imageBytes, imageName);
    return JasaModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<JasaModel> updateJasa(
    JasaModel jasa, {
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final res =
        await _write('PATCH', '/jasa/${jasa.id}', jasa, imageBytes, imageName);
    return JasaModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<JasaModel> setActive(String id, bool isActive) async {
    final res = await _api.patch('/jasa/$id', body: {'isActive': isActive});
    return JasaModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<void> deleteJasa(String id) async {
    await _api.delete('/jasa/$id');
  }

  // --------------------------------------------------------------- private

  Future<Map<String, dynamic>> _write(
    String method,
    String path,
    JasaModel jasa,
    Uint8List? imageBytes,
    String? imageName,
  ) {
    final options = jasa.options
        .map((o) => {'id': o.id, 'title': o.title, 'price': o.price})
        .toList();

    if (imageBytes != null) {
      // Ada gambar baru -> multipart (options dikirim sebagai string JSON).
      return _api.multipart(
        method,
        path,
        fields: {
          'title': jasa.title,
          'description': jasa.description,
          'category': jasa.category,
          'price': jasa.price.toString(),
          'priceType': jasa.priceType,
          'priceUnit': jasa.priceUnit,
          'location': jasa.location,
          'isActive': jasa.isActive.toString(),
          'options': jsonEncode(options),
        },
        files: [
          UploadFile(
            field: 'image',
            bytes: imageBytes,
            filename: imageName ?? 'jasa.jpg',
          )
        ],
      );
    }

    final body = <String, dynamic>{
      'title': jasa.title,
      'description': jasa.description,
      'category': jasa.category,
      'price': jasa.price,
      'priceType': jasa.priceType,
      'priceUnit': jasa.priceUnit,
      'location': jasa.location,
      'isActive': jasa.isActive,
      'options': options,
    };
    return method == 'POST'
        ? _api.post(path, body: body)
        : _api.patch(path, body: body);
  }

  List<JasaModel> _parseList(dynamic data) {
    final list = (data as List?) ?? const [];
    return list
        .map((e) => JasaModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
