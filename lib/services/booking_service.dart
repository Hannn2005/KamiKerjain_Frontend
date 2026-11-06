import '../models/booking_model.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final String _uuid = DateTime.now().millisecondsSinceEpoch.toString();

  final List<BookingModel> _bookings = [];

  void createBooking(BookingModel booking) {
    final newBooking = BookingModel(
      id: _uuid,
      jasaId: booking.jasaId,
      jasaTitle: booking.jasaTitle,
      customerId: booking.customerId,
      customerName: booking.customerName,
      penyediaId: booking.penyediaId,
      penyediaName: booking.penyediaName,
      price: booking.price,
      status: 'pending',
      notes: booking.notes,
      createdAt: DateTime.now(),
    );
    _bookings.add(newBooking);
  }

  List<BookingModel> getBookingsByCustomer(String customerId) {
    return _bookings.where((b) => b.customerId == customerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<BookingModel> getBookingsByPenyedia(String penyediaId) {
    return _bookings.where((b) => b.penyediaId == penyediaId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final old = _bookings[index];
      _bookings[index] = BookingModel(
        id: old.id,
        jasaId: old.jasaId,
        jasaTitle: old.jasaTitle,
        customerId: old.customerId,
        customerName: old.customerName,
        penyediaId: old.penyediaId,
        penyediaName: old.penyediaName,
        price: old.price,
        status: newStatus,
        notes: old.notes,
        reviewText: old.reviewText,
        reviewRating: old.reviewRating,
        createdAt: old.createdAt,
        completedAt: (newStatus == 'completed') ? DateTime.now() : old.completedAt,
      );
    }
  }

  void addReview(String bookingId, double rating, String reviewText) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final old = _bookings[index];
      _bookings[index] = BookingModel(
        id: old.id,
        jasaId: old.jasaId,
        jasaTitle: old.jasaTitle,
        customerId: old.customerId,
        customerName: old.customerName,
        penyediaId: old.penyediaId,
        penyediaName: old.penyediaName,
        price: old.price,
        status: old.status,
        notes: old.notes,
        reviewText: reviewText,
        reviewRating: rating,
        createdAt: old.createdAt,
        completedAt: old.completedAt,
      );
    }
  }

  BookingModel? getBookingById(String id) {
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }
}
