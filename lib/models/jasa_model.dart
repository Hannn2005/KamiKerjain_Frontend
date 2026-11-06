class JasaOption {
  final String id;
  final String title;
  final double price;

  JasaOption({
    required this.id,
    required this.title,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
    };
  }

  factory JasaOption.fromMap(Map<String, dynamic> map) {
    return JasaOption(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }
}

class JasaModel {
  final String id;
  final String penyediaId;
  final String penyediaName;
  final String title;
  final String description;
  final String category;
  final double price; // Base price / starting price
  final String priceType; // 'starting_from', 'fixed', 'hourly', 'survey'
  final String priceUnit; // e.g., '/ proyek', '/ jam', '/ sesi', '/ tugas'
  final List<JasaOption> options; // Dynamic add-ons/options
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
    this.priceType = 'starting_from',
    this.priceUnit = '/ proyek',
    this.options = const [],
    required this.location,
    this.imageUrl,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    required this.createdAt,
  });

  String get formattedPriceType {
    switch (priceType) {
      case 'starting_from':
        return 'Mulai dari';
      case 'hourly':
        return 'Per Jam';
      case 'survey':
        return 'Estimasi Survey';
      case 'fixed':
      default:
        return 'Harga Pas';
    }
  }

  JasaModel copyWith({
    String? id,
    String? penyediaId,
    String? penyediaName,
    String? title,
    String? description,
    String? category,
    double? price,
    String? priceType,
    String? priceUnit,
    List<JasaOption>? options,
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
      priceType: priceType ?? this.priceType,
      priceUnit: priceUnit ?? this.priceUnit,
      options: options ?? this.options,
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
      'priceType': priceType,
      'priceUnit': priceUnit,
      'options': options.map((o) => o.toMap()).toList(),
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,
      'totalReviews': totalReviews,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JasaModel.fromMap(Map<String, dynamic> map) {
    var rawOptions = map['options'];
    List<JasaOption> optionsList = [];
    if (rawOptions is List) {
      optionsList = rawOptions.map((item) => JasaOption.fromMap(item)).toList();
    }

    return JasaModel(
      id: map['id'] ?? '',
      penyediaId: map['penyediaId'] ?? '',
      penyediaName: map['penyediaName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      priceType: map['priceType'] ?? 'starting_from',
      priceUnit: map['priceUnit'] ?? '/ proyek',
      options: optionsList,
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews']?.toInt() ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
