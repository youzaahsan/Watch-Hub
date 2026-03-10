// lib/features/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../models/watch_model.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/gold_button.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final orders = context.watch<OrderProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;

    final tabs = ['Dashboard', 'Products', 'Orders'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppNavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.gold,
                  size: 28,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(
                    Icons.storefront_outlined,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                  label: const Text(
                    'View Store',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              children: tabs.asMap().entries.map((e) {
                final active = _tab == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _tab = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active ? AppColors.gold : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: active ? AppColors.gold : AppColors.border,
                      ),
                    ),
                    child: Text(
                      e.value,
                      style: TextStyle(
                        color: active
                            ? AppColors.bg
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: active
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: AppColors.border),
          // Content
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [
                _buildDashboard(products, orders, isWide),
                _buildProductsTab(products),
                _buildOrdersTab(orders),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    ProductProvider products,
    OrderProvider orders,
    bool isWide,
  ) {
    final stats = [
      {
        'label': 'Total Products',
        'value': '${products.watches.length}',
        'icon': Icons.inventory_2_outlined,
        'color': AppColors.gold,
      },
      {
        'label': 'Total Orders',
        'value': '${orders.orders.length}',
        'icon': Icons.receipt_long_outlined,
        'color': AppColors.accent,
      },
      {
        'label': 'Featured',
        'value': '${products.featuredWatches.length}',
        'icon': Icons.star_outline,
        'color': AppColors.warning,
      },
      {
        'label': 'On Sale',
        'value': '${products.onSale.length}',
        'icon': Icons.local_offer_outlined,
        'color': AppColors.success,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          // Stats cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 4 : 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 2.2,
            ),
            itemCount: stats.length,
            itemBuilder: (_, i) {
              final s = stats[i];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      s['icon'] as IconData,
                      color: s['color'] as Color,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          s['value'] as String,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          s['label'] as String,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.2, end: 0);
            },
          ),
          const SizedBox(height: 28),
          const Text(
            'Recent Orders',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          if (orders.orders.isEmpty)
            const Text(
              'No orders yet',
              style: TextStyle(color: AppColors.textMuted),
            )
          else
            ...orders.orders
                .take(5)
                .map(
                  (order) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.receipt_outlined,
                          color: AppColors.gold,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '#${order.id.substring(0, 8).toUpperCase()}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          order.statusLabel,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Rs ${(order.totalAmount / 1000).toStringAsFixed(0)}K',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 24),
          Row(
            children: [
              GoldButton(
                label: 'Manage Products',
                onPressed: () => setState(() => _tab = 1),
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(width: 12),
              GoldButton(
                label: 'View Orders',
                outline: true,
                onPressed: () => setState(() => _tab = 2),
                icon: Icons.receipt_long_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab(ProductProvider products) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${products.watches.length} Products',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              GoldButton(
                label: 'Add Product',
                icon: Icons.add,
                onPressed: () => _showAddProductDialog(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: products.watches.length,
            itemBuilder: (_, i) {
              final w = products.watches[i];
              return _AdminProductCard(
                watch: w,
              ).animate(delay: (i * 50).ms).fadeIn(duration: 250.ms);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersTab(OrderProvider orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: orders.orders.isEmpty ? 1 : orders.orders.length,
      itemBuilder: (_, i) {
        if (orders.orders.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Text(
                'No orders yet',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
            ),
          );
        }
        final order = orders.orders[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _StatusDropdown(order: order, orderProvider: orders),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${order.items.length} items • Rs ${(order.totalAmount / 1000).toStringAsFixed(0)}K',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              Text(
                '${order.shippingAddress['name'] ?? ''} • ${order.shippingAddress['city'] ?? ''}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ).animate(delay: (i * 60).ms).fadeIn();
      },
    );
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add Product',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: brandCtrl,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Price (Rs)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Product added (Firebase integration required for persistence)',
                  ),
                  backgroundColor: AppColors.card,
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _AdminProductCard extends StatelessWidget {
  final WatchModel watch;
  const _AdminProductCard({required this.watch});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: watch.images.isNotEmpty
                ? Image.network(
                    watch.images.first,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.watch,
                      color: AppColors.gold,
                      size: 40,
                    ),
                  )
                : const Icon(Icons.watch, color: AppColors.gold, size: 40),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  watch.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  watch.brand,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Rs ${(watch.effectivePrice / 1000).toStringAsFixed(0)}K • ${watch.category}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (watch.isFeatured)
                const Icon(Icons.star, color: AppColors.gold, size: 14),
              if (watch.isNew)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.fiber_new,
                    color: AppColors.success,
                    size: 14,
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.silver,
                  size: 18,
                ),
                onPressed: () {},
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 18,
                ),
                onPressed: () {},
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  final OrderModel order;
  final OrderProvider orderProvider;
  const _StatusDropdown({required this.order, required this.orderProvider});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      'pending',
      'processing',
      'shipped',
      'delivered',
      'cancelled',
    ];
    return PopupMenuButton<String>(
      color: AppColors.card,
      initialValue: order.status,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              order.statusLabel,
              style: const TextStyle(color: AppColors.gold, fontSize: 12),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textMuted,
              size: 14,
            ),
          ],
        ),
      ),
      itemBuilder: (_) => statuses
          .map(
            (s) => PopupMenuItem(
              value: s,
              child: Text(
                s[0].toUpperCase() + s.substring(1),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
          )
          .toList(),
      onSelected: (s) => orderProvider.updateOrderStatus(order.id, s),
    );
  }
}
