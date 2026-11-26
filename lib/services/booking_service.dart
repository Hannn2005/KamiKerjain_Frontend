import '../models/booking_model.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  int _counter = 0;
  String _newId() => 'bkg_${DateTime.now().millisecondsSinceEpoch}_${_counter++}';

  final List<BookingModel> _bookings = [];

  /// Membuat booking baru dan mengembalikan booking yang tersimpan
  /// (dengan ID unik) agar bisa dipakai di layar berikutnya (mis. pembayaran).
  BookingModel createBooking(BookingModel booking) {
    final newBooking = BookingModel(
      id: _newId(),
      jasaId: booking.jasaId,
      jasaTitle: booking.jasaTitle,
      customerId: booking.customerId,
      customerName: booking.customerName,
      penyediaId: booking.penyediaId,
      penyediaName: booking.penyediaName,
      price: booking.price,
      basePrice: booking.basePrice,
      selectedOptions: booking.selectedOptions,
      optionsTotalPrice: booking.optionsTotalPrice,
      priceNote: booking.priceNote,
      status: 'pending',
      notes: booking.notes,
      createdAt: DateTime.now(),
    );
    _bookings.add(newBooking);
    return newBooking;
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
      _bookings[index] = _bookings[index].copyWith(
        status: newStatus,
        completedAt: newStatus == 'completed' ? DateTime.now() : null,
      );
    }
  }

  /// Customer membatalkan pesanan. Hanya boleh saat status masih 'pending'
  /// (menunggu). Mengembalikan true jika berhasil dibatalkan.
  bool cancelBookingByCustomer(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) return false;
    if (_bookings[index].status != 'pending') return false;
    _bookings[index] = _bookings[index].copyWith(status: 'cancelled');
    return true;
  }

  /// Apakah jasa ini masih punya pesanan yang berjalan (belum final)?
  bool hasActiveBookingForJasa(String jasaId) {
    const activeStatuses = ['pending', 'accepted', 'in_progress'];
    return _bookings.any((b) => b.jasaId == jasaId && activeStatuses.contains(b.status));
  }

  void addReview(String bookingId, double rating, String reviewText) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        reviewText: reviewText,
        reviewRating: rating,
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
