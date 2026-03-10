// lib/widgets/watch_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/watch_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class WatchCard extends StatefulWidget {
  final WatchModel watch;
  final bool compact;

  const WatchCard({super.key, required this.watch, this.compact = false});

  @override
  State<WatchCard> createState() => _WatchCardState();
}

class _WatchCardState extends State<WatchCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _cartAnim;

  @override
  void initState() {
    super.initState();
    _cartAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _cartAnim.dispose();
    super.dispose();
  }

  void _addToCart(BuildContext context) {
    context.read<CartProvider>().addToCart(widget.watch);
    _cartAnim.forward().then((_) => _cartAnim.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.gold, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.watch.name} added to cart',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.watch<CartProvider>();
    final isWishlisted = wishlist.isWishlisted(widget.watch.id);
    final inCart = cart.isInCart(widget.watch.id);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.push('/product/${widget.watch.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0, -4, 0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.gold.withOpacity(0.4)
                  : AppColors.border,
              width: 0.8,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.12),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: widget.watch.images.isNotEmpty
                            ? widget.watch.images.first
                            : 'https://via.placeholder.com/400x400',
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.gold,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.watch,
                            color: AppColors.gold,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Badges
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      children: [
                        if (widget.watch.isNew)
                          _buildBadge('NEW', AppColors.gold, AppColors.bg),
                        if (widget.watch.isNew && widget.watch.isBestSeller)
                          const SizedBox(height: 4),
                        if (widget.watch.isBestSeller)
                          _buildBadge(
                            'HOT',
                            const Color(0xFFE53935),
                            Colors.white,
                          ),
                        if ((widget.watch.isNew || widget.watch.isBestSeller) &&
                            widget.watch.isOnSale)
                          const SizedBox(height: 4),
                        if (widget.watch.isOnSale)
                          _buildBadge(
                            '-${widget.watch.discountPercent.toInt()}%',
                            const Color(0xFF4CAF50),
                            Colors.white,
                          ),
                      ],
                    ),
                  ),
                  // Wishlist btn
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => wishlist.toggle(widget.watch),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: isWishlisted
                              ? AppColors.gold.withOpacity(0.15)
                              : AppColors.bg.withOpacity(0.6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isWishlisted
                                ? AppColors.gold
                                : AppColors.border,
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted
                              ? AppColors.gold
                              : AppColors.silver,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Info
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.watch.brand,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.watch.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: widget.watch.rating,
                          itemBuilder: (_, __) =>
                              const Icon(Icons.star, color: AppColors.gold),
                          itemCount: 5,
                          itemSize: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.watch.reviewCount})',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Rs ${_formatPrice(widget.watch.effectivePrice)}',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (widget.watch.isOnSale) ...[
                          const SizedBox(width: 6),
                          Text(
                            'Rs ${_formatPrice(widget.watch.price)}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Add to Cart
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: _cartAnim,
                        builder: (_, __) => GestureDetector(
                          onTap: () => _addToCart(context),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: inCart
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        AppColors.goldDark,
                                        AppColors.gold,
                                      ],
                                    ),
                              color: inCart ? AppColors.surface : null,
                              borderRadius: BorderRadius.circular(8),
                              border: inCart
                                  ? Border.all(color: AppColors.gold, width: 1)
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  inCart
                                      ? Icons.check_circle_outline
                                      : Icons.shopping_cart_outlined,
                                  size: 15,
                                  color: inCart
                                      ? AppColors.gold
                                      : AppColors.bg,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  inCart ? 'In Cart' : 'Add to Cart',
                                  style: TextStyle(
                                    color: inCart
                                        ? AppColors.gold
                                        : AppColors.bg,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) return '${(price / 1000000).toStringAsFixed(1)}M';
    if (price >= 1000) return '${(price / 1000).toStringAsFixed(0)}K';
    return price.toStringAsFixed(0);
  }
}
