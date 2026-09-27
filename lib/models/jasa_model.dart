class JasaModel {
  final String id;
  final String penyediaId;
  final String penyediaName;
  final String title;
  final String description;
  final String category;
  final double price;
  final String location;
  final String? imageUrl;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final DateTime createdAt;

  JasaModel({
    required this.id,
    required this.penyediaId,
    required this.penyediaName,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.location,
    this.imageUrl,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    required this.createdAt,
  });

  JasaModel copyWith({
    String? id,
    String? penyediaId,
    String? penyediaName,
    String? title,
    String? description,
    String? category,
    double? price,
    String? location,
    String? imageUrl,
    double? rating,
    int? totalReviews,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return JasaModel(
      id: id ?? this.id,
      penyediaId: penyediaId ?? this.penyediaId,
      penyediaName: penyediaName ?? this.penyediaName,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'penyediaId': penyediaId,
      'penyediaName': penyediaName,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,
      'totalReviews': totalReviews,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JasaModel.fromMap(Map<String, dynamic> map) {
    return JasaModel(
      id: map['id'] ?? '',
      penyediaId: map['penyediaId'] ?? '',
      penyediaName: map['penyediaName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews']?.toInt() ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
