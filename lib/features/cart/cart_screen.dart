// lib/features/cart/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/gold_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponCtrl = TextEditingController();
  bool _couponApplied = false;
  bool _couponError = false;

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppNavBar(),
      drawer: const AppDrawer(),
      body: cart.items.isEmpty
          ? _buildEmptyCart(context)
          : isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _buildCartList(cart)),
                Expanded(flex: 4, child: _buildSummary(cart, context)),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [_buildCartList(cart), _buildSummary(cart, context)],
              ),
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.textMuted,
            size: 72,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some watches to get started',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 24),
          GoldButton(
            label: 'Continue Shopping',
            icon: Icons.arrow_back,
            onPressed: () => context.push('/shop'),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildCartList(CartProvider cart) {
    return ListView.builder(
      shrinkWrap: true,
      physics: MediaQuery.of(context).size.width < 900
          ? const NeverScrollableScrollPhysics()
          : null,
      padding: const EdgeInsets.all(24),
      itemCount: cart.items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cart (${cart.itemCount} items)',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: cart.clearCart,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        }
        final item = cart.items.values.elementAt(index - 1);
        return Dismissible(
          key: Key(item.watch.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => cart.removeFromCart(item.watch.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: item.watch.images.isNotEmpty
                        ? item.watch.images.first
                        : '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.watch.brand,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        item.watch.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rs ${_formatPrice(item.watch.effectivePrice)}',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    // Qty control
                    Row(
                      children: [
                        _qtyBtn(
                          Icons.remove,
                          () => cart.decreaseQuantity(item.watch.id),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _qtyBtn(
                          Icons.add,
                          () => cart.increaseQuantity(item.watch.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rs ${_formatPrice(item.totalPrice)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0),
        );
      },
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
          color: AppColors.surface,
        ),
        child: Icon(icon, size: 14, color: AppColors.gold),
      ),
    );
  }

  Widget _buildSummary(CartProvider cart, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _summaryRow('Subtotal', 'Rs ${_formatPrice(cart.subtotal)}'),
          if (cart.discount > 0)
            _summaryRow(
              'Coupon Discount',
              '-Rs ${_formatPrice(cart.discount)}',
              valueColor: AppColors.success,
            ),
          _summaryRow('Shipping', 'Free', valueColor: AppColors.success),
          const Divider(color: AppColors.border, height: 24),
          _summaryRow('Total', 'Rs ${_formatPrice(cart.total)}', isTotal: true),
          const SizedBox(height: 20),
          // Coupon
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponCtrl,
                  decoration: InputDecoration(
                    hintText: 'Coupon code',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _couponError
                            ? AppColors.error
                            : AppColors.border,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _couponError
                            ? AppColors.error
                            : _couponApplied
                            ? AppColors.success
                            : AppColors.border,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final code = _couponCtrl.text.trim();
                  final valid = cart.applyCoupon(code);
                  setState(() {
                    _couponApplied = valid;
                    _couponError = !valid && code.isNotEmpty;
                  });
                },
                child: const Text('Apply'),
              ),
            ],
          ),
          if (_couponApplied)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '✓ Coupon applied!',
                style: TextStyle(color: AppColors.success, fontSize: 12),
              ),
            ).animate().fadeIn().slideY(begin: -0.2),
          if (_couponError)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '✗ Invalid coupon code',
                style: TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ).animate().fadeIn().shake(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GoldButton(
              label: 'Proceed to Checkout',
              icon: Icons.arrow_forward,
              onPressed: () => context.push('/checkout'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => context.push('/shop'),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          ),
          // Tip labels
          const SizedBox(height: 12),
          const Text(
            'Try coupons: WATCH10 • HUB20 • LUXURY15',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.textPrimary : AppColors.textMuted,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color:
                  valueColor ??
                  (isTotal ? AppColors.gold : AppColors.textSecondary),
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
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
