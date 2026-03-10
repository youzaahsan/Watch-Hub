// lib/features/product/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../models/watch_model.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/watch_card.dart';
import '../../widgets/section_header.dart';

class ProductDetailScreen extends StatefulWidget {
  final String watchId;
  const ProductDetailScreen({super.key, required this.watchId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImage = 0;
  bool _imageZoom = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().addToRecentlyViewed(widget.watchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final watch = products.getById(widget.watchId);
    final isWide = MediaQuery.of(context).size.width > 900;

    if (watch == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: const AppNavBar(),
        body: const Center(
          child: Text(
            'Watch not found',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final related = products.watches
        .where((w) => w.category == watch.category && w.id != watch.id)
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppNavBar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildImageGallery(watch)),
                        const SizedBox(width: 48),
                        Expanded(
                          flex: 5,
                          child: _buildInfo(watch, cart, wishlist, context),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildImageGallery(watch),
                        const SizedBox(height: 24),
                        _buildInfo(watch, cart, wishlist, context),
                      ],
                    ),
            ),
            if (related.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'You May Also Like'),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 4 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio:
                            MediaQuery.of(context).size.width < 450
                            ? 0.47
                            : 0.65,
                      ),
                      itemCount: related.length,
                      itemBuilder: (_, i) => WatchCard(watch: related[i]),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(WatchModel watch) {
    return Column(
      children: [
        // Main image
        GestureDetector(
          onTap: () => setState(() => _imageZoom = !_imageZoom),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _imageZoom ? 500 : 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: CachedNetworkImage(
                    key: ValueKey(_selectedImage),
                    imageUrl: watch.images.isNotEmpty
                        ? watch.images[_selectedImage]
                        : 'https://via.placeholder.com/400x400',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.bg.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _imageZoom ? Icons.zoom_out : Icons.zoom_in,
                      color: AppColors.gold,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Thumbnails
        if (watch.images.length > 1)
          Row(
            children: watch.images.asMap().entries.map((entry) {
              final i = entry.key;
              final url = entry.value;
              return GestureDetector(
                onTap: () => setState(() => _selectedImage = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedImage == i
                          ? AppColors.gold
                          : AppColors.border,
                      width: _selectedImage == i ? 2 : 0.5,
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildInfo(
    WatchModel watch,
    CartProvider cart,
    WishlistProvider wishlist,
    BuildContext context,
  ) {
    final isWishlisted = wishlist.isWishlisted(watch.id);
    final inCart = cart.isInCart(watch.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gold.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            watch.brand.toUpperCase(),
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          watch.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        // Rating
        Row(
          children: [
            RatingBarIndicator(
              rating: watch.rating,
              itemBuilder: (_, __) =>
                  const Icon(Icons.star, color: AppColors.gold),
              itemCount: 5,
              itemSize: 18,
            ),
            const SizedBox(width: 8),
            Text(
              '${watch.rating} (${watch.reviewCount} reviews)',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rs ${_formatPrice(watch.effectivePrice)}',
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (watch.isOnSale) ...[
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rs ${_formatPrice(watch.price)}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${watch.discountPercent.toInt()}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        // Stock
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              watch.stock > 0
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color: watch.stock > 0 ? AppColors.success : AppColors.error,
              size: 15,
            ),
            const SizedBox(width: 6),
            Text(
              watch.stock > 0
                  ? 'In Stock (${watch.stock} left)'
                  : 'Out of Stock',
              style: TextStyle(
                color: watch.stock > 0 ? AppColors.success : AppColors.error,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Divider(color: AppColors.border),
        const SizedBox(height: 18),
        // Description
        Text(
          watch.description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        // Specs
        if (watch.specs != null) ...[
          const SizedBox(height: 20),
          const Text(
            'Specifications',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...watch.specs!.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value.toString(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        // Buttons
        Row(
          children: [
            Expanded(
              flex: 3,
              child: GoldButton(
                label: inCart ? 'In Cart' : 'Add to Cart',
                icon: inCart ? Icons.check : Icons.shopping_cart_outlined,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                onPressed: watch.stock > 0
                    ? () {
                        cart.addToCart(watch);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart!'),
                            backgroundColor: AppColors.card,
                          ),
                        );
                      }
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: GoldButton(
                label: 'Buy Now',
                outline: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                onPressed: watch.stock > 0
                    ? () {
                        cart.addToCart(watch);
                        context.push('/checkout');
                      }
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Wishlist
            GestureDetector(
              onTap: () => wishlist.toggle(watch),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isWishlisted
                      ? AppColors.gold.withOpacity(0.12)
                      : AppColors.surface,
                  border: Border.all(
                    color: isWishlisted ? AppColors.gold : AppColors.border,
                  ),
                ),
                child: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? AppColors.gold : AppColors.silver,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Shipping info tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _tag(Icons.local_shipping_outlined, 'Free Shipping'),
            _tag(Icons.verified_outlined, 'Authentic'),
            _tag(Icons.replay, '30-Day Returns'),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _tag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gold, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) return '${(price / 1000000).toStringAsFixed(1)}M';
    if (price >= 1000) return '${(price / 1000).toStringAsFixed(0)}K';
    return price.toStringAsFixed(0);
  }
}
