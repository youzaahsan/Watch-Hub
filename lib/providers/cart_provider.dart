// lib/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/watch_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String? _couponCode;
  double _discount = 0;

  Map<String, CartItem> get items => _items;
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  String? get couponCode => _couponCode;
  double get discount => _discount;

  bool isInCart(String watchId) => _items.containsKey(watchId);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal - _discount;

  void addToCart(WatchModel watch) {
    if (_items.containsKey(watch.id)) {
      _items[watch.id]!.quantity += 1;
    } else {
      _items[watch.id] = CartItem(watch: watch);
    }
    notifyListeners();
  }

  void removeFromCart(String watchId) {
    _items.remove(watchId);
    notifyListeners();
  }

  void increaseQuantity(String watchId) {
    if (_items.containsKey(watchId)) {
      _items[watchId]!.quantity += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(String watchId) {
    if (_items.containsKey(watchId)) {
      if (_items[watchId]!.quantity > 1) {
        _items[watchId]!.quantity -= 1;
      } else {
        _items.remove(watchId);
      }
      notifyListeners();
    }
  }

  bool applyCoupon(String code) {
    final validCoupons = {'WATCH10': 0.10, 'HUB20': 0.20, 'LUXURY15': 0.15};
    if (validCoupons.containsKey(code.toUpperCase())) {
      _couponCode = code.toUpperCase();
      _discount = subtotal * validCoupons[code.toUpperCase()]!;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _couponCode = null;
    _discount = 0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _couponCode = null;
    _discount = 0;
    notifyListeners();
  }

  List<Map<String, dynamic>> toOrderItems() {
    return _items.values.map((item) => item.toMap()).toList();
  }
}
