class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String role; // 'customer', 'penyedia', 'admin'
  final String status; // 'approved', 'pending', 'rejected'
  final String? profileImage;
  final String? address;
  final String? description; // for penyedia jasa
  final String? category; // primary category for penyedia
  final String? cvFileName; // CV / Certification document file name
  final String? portfolioText; // description of work proof & experience
  final String? rejectionReason; // if rejected by admin
  final double rating;
  final int totalReviews;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.status = 'approved',
    this.profileImage,
    this.address,
    this.description,
    this.category,
    this.cvFileName,
    this.portfolioText,
    this.rejectionReason,
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
    String? status,
    String? profileImage,
    String? address,
    String? description,
    String? category,
    String? cvFileName,
    String? portfolioText,
    String? rejectionReason,
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
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      description: description ?? this.description,
      category: category ?? this.category,
      cvFileName: cvFileName ?? this.cvFileName,
      portfolioText: portfolioText ?? this.portfolioText,
      rejectionReason: rejectionReason ?? this.rejectionReason,
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
      'status': status,
      'profileImage': profileImage,
      'address': address,
      'description': description,
      'category': category,
      'cvFileName': cvFileName,
      'portfolioText': portfolioText,
      'rejectionReason': rejectionReason,
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
      status: map['status'] ?? 'approved',
      profileImage: map['profileImage'],
      address: map['address'],
      description: map['description'],
      category: map['category'],
      cvFileName: map['cvFileName'],
      portfolioText: map['portfolioText'],
      rejectionReason: map['rejectionReason'],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
