// lib/models/cart_item_model.dart
import 'watch_model.dart';

class CartItem {
  final WatchModel watch;
  int quantity;

  CartItem({required this.watch, this.quantity = 1});

  double get totalPrice => watch.effectivePrice * quantity;

  Map<String, dynamic> toMap() => {
    'watchId': watch.id,
    'watchName': watch.name,
    'watchImage': watch.images.isNotEmpty ? watch.images.first : '',
    'price': watch.effectivePrice,
    'quantity': quantity,
  };
}
