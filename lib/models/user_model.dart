// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phone;
  final List<Map<String, dynamic>> addresses;
  final bool isAdmin;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phone,
    this.addresses = const [],
    this.isAdmin = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      phone: map['phone'],
      addresses: List<Map<String, dynamic>>.from(map['addresses'] ?? []),
      isAdmin: map['isAdmin'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'phone': phone,
    'addresses': addresses,
    'isAdmin': isAdmin,
    'createdAt': createdAt,
  };
}
