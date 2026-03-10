// lib/models/watch_model.dart
class WatchModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double? discountPrice;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String description;
  final bool isNew;
  final bool isFeatured;
  final bool isBestSeller;
  final Map<String, dynamic>? specs;
  final int stock;
  final DateTime createdAt;

  WatchModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.discountPrice,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.images,
    required this.description,
    this.isNew = false,
    this.isFeatured = false,
    this.isBestSeller = false,
    this.specs,
    this.stock = 0,
    required this.createdAt,
  });

  double get effectivePrice => discountPrice ?? price;

  double get discountPercent {
    if (discountPrice == null) return 0;
    return ((price - discountPrice!) / price * 100).roundToDouble();
  }

  bool get isOnSale => discountPrice != null && discountPrice! < price;

  factory WatchModel.fromMap(Map<String, dynamic> map, String id) {
    return WatchModel(
      id: id,
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: map['discountPrice'] != null
          ? (map['discountPrice']).toDouble()
          : null,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      images: List<String>.from(map['images'] ?? []),
      description: map['description'] ?? '',
      isNew: map['isNew'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      isBestSeller: map['isBestSeller'] ?? false,
      specs: map['specs'],
      stock: map['stock'] ?? 0,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'brand': brand,
    'category': category,
    'price': price,
    'discountPrice': discountPrice,
    'rating': rating,
    'reviewCount': reviewCount,
    'images': images,
    'description': description,
    'isNew': isNew,
    'isFeatured': isFeatured,
    'isBestSeller': isBestSeller,
    'specs': specs,
    'stock': stock,
    'createdAt': createdAt,
  };

  WatchModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? price,
    double? discountPrice,
    double? rating,
    int? reviewCount,
    List<String>? images,
    String? description,
    bool? isNew,
    bool? isFeatured,
    bool? isBestSeller,
    Map<String, dynamic>? specs,
    int? stock,
    DateTime? createdAt,
  }) {
    return WatchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      images: images ?? this.images,
      description: description ?? this.description,
      isNew: isNew ?? this.isNew,
      isFeatured: isFeatured ?? this.isFeatured,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      specs: specs ?? this.specs,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
