class BookingModel {
  final String id;
  final String jasaId;
  final String jasaTitle;
  final String customerId;
  final String customerName;
  final String penyediaId;
  final String penyediaName;
  final double price;
  final String status; // 'pending', 'accepted', 'rejected', 'in_progress', 'completed', 'cancelled'
  final String? notes;
  final String? reviewText;
  final double? reviewRating;
  final DateTime createdAt;
  final DateTime? completedAt;

  BookingModel({
    required this.id,
    required this.jasaId,
    required this.jasaTitle,
    required this.customerId,
    required this.customerName,
    required this.penyediaId,
    required this.penyediaName,
    required this.price,
    required this.status,
    this.notes,
    this.reviewText,
    this.reviewRating,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jasaId': jasaId,
      'jasaTitle': jasaTitle,
      'customerId': customerId,
      'customerName': customerName,
      'penyediaId': penyediaId,
      'penyediaName': penyediaName,
      'price': price,
      'status': status,
      'notes': notes,
      'reviewText': reviewText,
      'reviewRating': reviewRating,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      jasaId: map['jasaId'] ?? '',
      jasaTitle: map['jasaTitle'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      penyediaId: map['penyediaId'] ?? '',
      penyediaName: map['penyediaName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      notes: map['notes'],
      reviewText: map['reviewText'],
      reviewRating: map['reviewRating']?.toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
    );
  }
}
