import 'package:http/http.dart' as http;

/// Mobile / desktop: client biasa. Cookie sesi dikelola manual oleh ApiClient.
http.Client createHttpClient() => http.Client();
