// lib/providers/product_provider.dart
import 'package:flutter/foundation.dart';
import '../models/watch_model.dart';
import '../services/mock_data_service.dart';

enum SortOption { latest, priceLow, priceHigh, rating, nameAZ }

class ProductProvider with ChangeNotifier {
  List<WatchModel> _allWatches = [];
  List<WatchModel> _filteredWatches = [];
  bool _isLoading = false;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  double _minPrice = 0;
  double _maxPrice = 2000000;
  SortOption _sortOption = SortOption.latest;
  List<String> _recentlyViewed = [];

  List<WatchModel> get watches => _filteredWatches;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedBrand => _selectedBrand;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  SortOption get sortOption => _sortOption;
  List<String> get recentlyViewedIds => _recentlyViewed;

  List<WatchModel> get featuredWatches =>
      _allWatches.where((w) => w.isFeatured).toList();
  List<WatchModel> get bestSellers =>
      _allWatches.where((w) => w.isBestSeller).toList();
  List<WatchModel> get newArrivals =>
      _allWatches.where((w) => w.isNew).toList();
  List<WatchModel> get onSale => _allWatches.where((w) => w.isOnSale).toList();

  WatchModel? getById(String id) {
    try {
      return _allWatches.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  List<WatchModel> getRecentlyViewed() {
    return _recentlyViewed
        .map((id) => getById(id))
        .where((w) => w != null)
        .cast<WatchModel>()
        .toList();
  }

  void addToRecentlyViewed(String watchId) {
    _recentlyViewed.remove(watchId);
    _recentlyViewed.insert(0, watchId);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed.removeLast();
    }
    notifyListeners();
  }

  Future<void> loadWatches() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _allWatches = MockDataService.getSampleWatches();
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void filterByBrand(String brand) {
    _selectedBrand = brand;
    _applyFilters();
  }

  void filterByPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void sort(SortOption option) {
    _sortOption = option;
    _applyFilters();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedBrand = 'All';
    _minPrice = 0;
    _maxPrice = 2000000;
    _sortOption = SortOption.latest;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredWatches = List.from(_allWatches);

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      _filteredWatches = _filteredWatches
          .where(
            (w) =>
                w.name.toLowerCase().contains(q) ||
                w.brand.toLowerCase().contains(q) ||
                w.category.toLowerCase().contains(q),
          )
          .toList();
    }

    if (_selectedCategory != 'All') {
      _filteredWatches = _filteredWatches
          .where((w) => w.category == _selectedCategory)
          .toList();
    }

    if (_selectedBrand != 'All') {
      _filteredWatches = _filteredWatches
          .where((w) => w.brand == _selectedBrand)
          .toList();
    }

    _filteredWatches = _filteredWatches
        .where(
          (w) => w.effectivePrice >= _minPrice && w.effectivePrice <= _maxPrice,
        )
        .toList();

    switch (_sortOption) {
      case SortOption.priceLow:
        _filteredWatches.sort(
          (a, b) => a.effectivePrice.compareTo(b.effectivePrice),
        );
        break;
      case SortOption.priceHigh:
        _filteredWatches.sort(
          (a, b) => b.effectivePrice.compareTo(a.effectivePrice),
        );
        break;
      case SortOption.rating:
        _filteredWatches.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.nameAZ:
        _filteredWatches.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.latest:
        _filteredWatches.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    notifyListeners();
  }
}
