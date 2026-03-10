// lib/providers/order_provider.dart
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  List<OrderModel> getOrdersByUser(String userId) =>
      _orders.where((o) => o.userId == userId).toList();

  Future<void> placeOrder(OrderModel order) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _orders.add(order);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = OrderModel(
        id: old.id,
        userId: old.userId,
        items: old.items,
        totalAmount: old.totalAmount,
        shippingAddress: old.shippingAddress,
        paymentMethod: old.paymentMethod,
        status: status,
        couponCode: old.couponCode,
        discount: old.discount,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }
}
