// lib/features/shop/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/watch_card.dart';
import '../../widgets/gold_button.dart';

class ShopScreen extends StatefulWidget {
  final String? category;
  final String? brand;

  const ShopScreen({super.key, this.category, this.brand});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _searchCtrl = TextEditingController();
  bool _filterVisible = false;
  RangeValues _priceRange = const RangeValues(0, 2000000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      provider.loadWatches();
      if (widget.category != null) provider.filterByCategory(widget.category!);
      if (widget.brand != null) provider.filterByBrand(widget.brand!);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppNavBar(),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'All Watches',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${products.watches.length} results',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Filter toggle
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.silver,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () =>
                          setState(() => _filterVisible = !_filterVisible),
                      icon: const Icon(Icons.tune, size: 16),
                      label: const Text(
                        'Filter',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Sort
                    _SortDropdown(
                      current: products.sortOption,
                      onSelected: products.sort,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search
                TextField(
                  controller: _searchCtrl,
                  onChanged: products.search,
                  decoration: const InputDecoration(
                    hintText: 'Search watches...',
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          // Filter panel
          if (_filterVisible)
            _FilterPanel(
              categories: [
                'All',
                ...context
                    .read<ProductProvider>()
                    .watches
                    .map((w) => w.category)
                    .toSet()
                    .toList(),
              ],
              brands: [
                'All',
                ...context
                    .read<ProductProvider>()
                    .watches
                    .map((w) => w.brand)
                    .toSet()
                    .toList(),
              ],
              selectedCategory: products.selectedCategory,
              selectedBrand: products.selectedBrand,
              priceRange: _priceRange,
              onCategoryChanged: (c) => products.filterByCategory(c),
              onBrandChanged: (b) => products.filterByBrand(b),
              onPriceChanged: (r) {
                setState(() => _priceRange = r);
                products.filterByPriceRange(r.start, r.end);
              },
              onReset: () {
                products.resetFilters();
                _searchCtrl.clear();
                setState(() => _priceRange = const RangeValues(0, 2000000));
              },
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),
          // Grid
          Expanded(
            child: products.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  )
                : products.watches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          color: AppColors.textMuted,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No watches found',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GoldButton(
                          label: 'Reset Filters',
                          outline: true,
                          onPressed: () {
                            products.resetFilters();
                            _searchCtrl.clear();
                          },
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: MediaQuery.of(context).size.width < 450
                          ? 0.47
                          : 0.65,
                    ),
                    itemCount: products.watches.length,
                    itemBuilder: (_, i) => WatchCard(watch: products.watches[i])
                        .animate(delay: (i * 60).ms)
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final SortOption current;
  final ValueChanged<SortOption> onSelected;

  const _SortDropdown({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      color: AppColors.card,
      initialValue: current,
      onSelected: onSelected,
      tooltip: 'Sort',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.sort, color: AppColors.silver, size: 16),
            SizedBox(width: 6),
            Text(
              'Sort',
              style: TextStyle(color: AppColors.silver, fontSize: 13),
            ),
          ],
        ),
      ),
      itemBuilder: (_) => [
        _sortItem(SortOption.latest, 'Latest'),
        _sortItem(SortOption.priceLow, 'Price: Low to High'),
        _sortItem(SortOption.priceHigh, 'Price: High to Low'),
        _sortItem(SortOption.rating, 'Top Rated'),
        _sortItem(SortOption.nameAZ, 'Name: A-Z'),
      ],
    );
  }

  PopupMenuItem<SortOption> _sortItem(SortOption value, String label) {
    return PopupMenuItem(
      value: value,
      child: Text(
        label,
        style: TextStyle(
          color: current == value ? AppColors.gold : AppColors.textPrimary,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  final List<String> categories;
  final List<String> brands;
  final String selectedCategory;
  final String selectedBrand;
  final RangeValues priceRange;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onBrandChanged;
  final ValueChanged<RangeValues> onPriceChanged;
  final VoidCallback onReset;

  const _FilterPanel({
    required this.categories,
    required this.brands,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.priceRange,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    required this.onPriceChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          Wrap(
            spacing: 8,
            children: categories.map((c) {
              final sel = c == selectedCategory;
              return ChoiceChip(
                label: Text(c),
                selected: sel,
                onSelected: (_) => onCategoryChanged(c),
                selectedColor: AppColors.gold,
                labelStyle: TextStyle(
                  color: sel ? AppColors.bg : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Brands
          Wrap(
            spacing: 8,
            children: brands.map((b) {
              final sel = b == selectedBrand;
              return ChoiceChip(
                label: Text(b),
                selected: sel,
                onSelected: (_) => onBrandChanged(b),
                selectedColor: AppColors.gold,
                labelStyle: TextStyle(
                  color: sel ? AppColors.bg : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Price range
          Row(
            children: [
              const Text(
                'Price:',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              Expanded(
                child: RangeSlider(
                  values: priceRange,
                  min: 0,
                  max: 2000000,
                  divisions: 40,
                  activeColor: AppColors.gold,
                  inactiveColor: AppColors.border,
                  onChanged: onPriceChanged,
                ),
              ),
              Text(
                'Rs ${(priceRange.end / 1000).toStringAsFixed(0)}K',
                style: const TextStyle(color: AppColors.gold, fontSize: 12),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onReset,
              child: const Text(
                'Reset All',
                style: TextStyle(color: AppColors.gold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
