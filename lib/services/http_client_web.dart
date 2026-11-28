import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

/// Web: browser yang mengelola cookie, jadi withCredentials harus aktif
/// supaya cookie sesi ikut terkirim ke backend (lintas origin).
http.Client createHttpClient() => BrowserClient()..withCredentials = true;
