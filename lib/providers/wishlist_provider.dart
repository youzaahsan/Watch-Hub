// lib/providers/wishlist_provider.dart
import 'package:flutter/foundation.dart';
import '../models/watch_model.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WatchModel> _items = {};

  Map<String, WatchModel> get items => _items;
  int get count => _items.length;

  bool isWishlisted(String watchId) => _items.containsKey(watchId);

  void toggle(WatchModel watch) {
    if (_items.containsKey(watch.id)) {
      _items.remove(watch.id);
    } else {
      _items[watch.id] = watch;
    }
    notifyListeners();
  }

  void remove(String watchId) {
    _items.remove(watchId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
