import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

import '../utils/api_config.dart';
import 'http_client_stub.dart'
    if (dart.library.js_interop) 'http_client_web.dart';

/// Error yang dilempar saat request ke backend gagal.
/// [message] sudah berupa teks yang siap ditampilkan ke pengguna.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// File yang dikirim sebagai multipart.
class UploadFile {
  final String field;
  final Uint8List bytes;
  final String filename;

  UploadFile({required this.field, required this.bytes, required this.filename});
}


class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = createHttpClient();
  final Map<String, String> _cookies = {};

  /// Hapus cookie sesi lokal (dipakai saat logout).
  void clearSession() => _cookies.clear();

  // ---------------------------------------------------------------- public

  Future<Map<String, dynamic>> get(String path, {Map<String, String?>? query}) {
    return _send(() => _client.get(_uri(path, query), headers: _headers()));
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) {
    return _send(() => _client.post(_uri(path),
        headers: _headers(json: true), body: jsonEncode(body ?? {})));
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) {
    return _send(() => _client.put(_uri(path),
        headers: _headers(json: true), body: jsonEncode(body ?? {})));
  }

  Future<Map<String, dynamic>> patch(String path, {Map<String, dynamic>? body}) {
    return _send(() => _client.patch(_uri(path),
        headers: _headers(json: true), body: jsonEncode(body ?? {})));
  }

  Future<Map<String, dynamic>> delete(String path) {
    return _send(() => _client.delete(_uri(path), headers: _headers()));
  }

  /// Kirim form multipart (dengan atau tanpa file).
  Future<Map<String, dynamic>> multipart(
    String method,
    String path, {
    Map<String, String> fields = const {},
    List<UploadFile> files = const [],
  }) {
    return _send(() async {
      final request = http.MultipartRequest(method, _uri(path));
      request.headers.addAll(_headers());
      request.fields.addAll(fields);
      for (final f in files) {
        request.files.add(http.MultipartFile.fromBytes(
          f.field,
          f.bytes,
          filename: f.filename,
          contentType: _mediaTypeFor(f.filename),
        ));
      }
      final streamed = await _client.send(request);
      return http.Response.fromStream(streamed);
    });
  }

  // --------------------------------------------------------------- private

  Uri _uri(String path, [Map<String, String?>? query]) {
    final clean = <String, String>{};
    query?.forEach((k, v) {
      if (v != null && v.isNotEmpty) clean[k] = v;
    });
    final base = Uri.parse('${ApiConfig.baseUrl}$path');
    return clean.isEmpty ? base : base.replace(queryParameters: clean);
  }

  Map<String, String> _headers({bool json = false}) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (json) headers['Content-Type'] = 'application/json';
    if (!kIsWeb && _cookies.isNotEmpty) {
      headers['Cookie'] =
          _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    return headers;
  }

  Future<Map<String, dynamic>> _send(
      Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request().timeout(ApiConfig.timeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }

    _storeCookies(response);

    Map<String, dynamic> body = {};
    if (response.body.isNotEmpty) {
      try {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map<String, dynamic>) body = decoded;
      } catch (_) {
        // Body bukan JSON (mis. halaman error dari proxy).
      }
    }

    final ok = response.statusCode >= 200 &&
        response.statusCode < 300 &&
        body['success'] != false;
    if (!ok) {
      final message = body['message']?.toString() ??
          'Terjadi kesalahan (kode ${response.statusCode}).';
      throw ApiException(message, statusCode: response.statusCode);
    }
    return body;
  }

  /// Simpan cookie sesi dari header Set-Cookie (hanya non-web).
  void _storeCookies(http.Response response) {
    if (kIsWeb) return;
    final raw = response.headers['set-cookie'];
    if (raw == null || raw.isEmpty) return;

    // http menggabungkan beberapa Set-Cookie dengan koma; pisahkan hanya di
    // koma yang diikuti "nama=" supaya tanggal "Expires=Thu, 01 Jan ..." aman.
    final cookies = raw.split(RegExp(r',(?=\s*[A-Za-z0-9_.\-]+=)'));
    for (final cookie in cookies) {
      final pair = cookie.split(';').first.trim();
      final eq = pair.indexOf('=');
      if (eq <= 0) continue;
      final name = pair.substring(0, eq);
      final value = pair.substring(eq + 1);
      final lower = cookie.toLowerCase();
      final expired = value.isEmpty ||
          lower.contains('max-age=0') ||
          lower.contains('expires=thu, 01 jan 1970');
      if (expired) {
        _cookies.remove(name);
      } else {
        _cookies[name] = value;
      }
    }
  }

  /// Backend (multer) memfilter berdasarkan mimetype, jadi harus eksplisit.
  MediaType _mediaTypeFor(String filename) {
    final ext = filename.contains('.') ? filename.split('.').last.toLowerCase() : '';
    switch (ext) {
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      case 'gif':
        return MediaType('image', 'gif');
      case 'doc':
        return MediaType('application', 'msword');
      case 'docx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      default:
        return MediaType('application', 'octet-stream');
    }
  }
}
