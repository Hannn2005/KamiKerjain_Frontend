class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String role; // 'customer' or 'penyedia'
  final String? profileImage;
  final String? address;
  final String? description; // for penyedia jasa
  final double rating;
  final int totalReviews;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage,
    this.address,
    this.description,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    String? address,
    String? description,
    double? rating,
    int? totalReviews,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'profileImage': profileImage,
      'address': address,
      'description': description,
      'rating': rating,
      'totalReviews': totalReviews,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      profileImage: map['profileImage'],
      address: map['address'],
      description: map['description'],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
