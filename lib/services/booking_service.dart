import '../models/booking_model.dart';
import '../models/jasa_model.dart';
import 'api_client.dart';

/// Pemesanan jasa lewat REST API (`/api/bookings`).
/// Daftar yang dikembalikan `getMyBookings` otomatis disesuaikan server
/// dengan role user yang sedang login (customer / penyedia / admin).
class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final ApiClient _api = ApiClient();

  static const List<String> activeStatuses = ['pending', 'accepted', 'in_progress'];

  /// Buat booking. Harga total dihitung server dari harga dasar + opsi terpilih.
  Future<BookingModel> createBooking({
    required String jasaId,
    List<JasaOption> selectedOptions = const [],
    String? notes,
    String? priceNote,
  }) async {
    final res = await _api.post('/bookings', body: {
      'jasaId': jasaId,
      'selectedOptions':
          selectedOptions.map((o) => {'id': o.id, 'title': o.title}).toList(),
      'notes': notes,
      'priceNote': priceNote,
    });
    return BookingModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<List<BookingModel>> getMyBookings() async {
    final res = await _api.get('/bookings');
    final list = (res['data'] as List?) ?? const [];
    return list
        .map((e) => BookingModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<BookingModel> getBookingById(String id) async {
    final res = await _api.get('/bookings/$id');
    return BookingModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  Future<BookingModel> updateBookingStatus(String bookingId, String status) async {
    final res =
        await _api.patch('/bookings/$bookingId/status', body: {'status': status});
    return BookingModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  /// Customer membatalkan pesanan (server hanya mengizinkan saat `pending`).
  Future<BookingModel> cancelBooking(String bookingId) {
    return updateBookingStatus(bookingId, 'cancelled');
  }

  Future<BookingModel> addReview(String bookingId, double rating, String reviewText) async {
    final res = await _api.post('/bookings/$bookingId/review', body: {
      'rating': rating,
      'reviewText': reviewText,
    });
    return BookingModel.fromMap(res['data'] as Map<String, dynamic>);
  }

  /// Apakah jasa ini masih punya pesanan berjalan? (dipakai penyedia sebelum menghapus jasa)
  Future<bool> hasActiveBookingForJasa(String jasaId) async {
    final bookings = await getMyBookings();
    return bookings.any(
        (b) => b.jasaId == jasaId && activeStatuses.contains(b.status));
  }
}
