// lib/models/order_model.dart
class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final Map<String, dynamic> shippingAddress;
  final String paymentMethod;
  final String status; // pending, processing, shipped, delivered, cancelled
  final String? couponCode;
  final double? discount;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = 'pending',
    this.couponCode,
    this.discount,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      shippingAddress: Map<String, dynamic>.from(map['shippingAddress'] ?? {}),
      paymentMethod: map['paymentMethod'] ?? 'cod',
      status: map['status'] ?? 'pending',
      couponCode: map['couponCode'],
      discount: map['discount']?.toDouble(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'items': items,
    'totalAmount': totalAmount,
    'shippingAddress': shippingAddress,
    'paymentMethod': paymentMethod,
    'status': status,
    'couponCode': couponCode,
    'discount': discount,
    'createdAt': createdAt,
  };

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
