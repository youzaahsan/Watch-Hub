// lib/features/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order_model.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/gold_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'cod';
  bool _isPlacing = false;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppNavBar(),
      body: Column(
        children: [
          // Steps indicator
          _buildStepsBar(),
          Expanded(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _buildStepContent()),
                      Expanded(flex: 4, child: _buildOrderSummary(cart)),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [_buildStepContent(), _buildOrderSummary(cart)],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsBar() {
    final steps = ['Shipping', 'Payment', 'Review'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final isActive = _step == i;
          final isDone = _step > i;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? AppColors.success
                              : isActive
                              ? AppColors.gold
                              : AppColors.surface,
                          border: Border.all(
                            color: isActive
                                ? AppColors.gold
                                : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: isActive
                                        ? AppColors.bg
                                        : AppColors.textMuted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.gold
                              : AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.only(bottom: 20),
                      color: _step > i
                          ? AppColors.success
                          : AppColors.border,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildShippingForm();
      case 1:
        return _buildPaymentStep();
      case 2:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildShippingForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Information',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _formField(
              _nameCtrl,
              'Full Name',
              Icons.person_outline,
              required: true,
            ),
            _formField(
              _phoneCtrl,
              'Phone Number',
              Icons.phone_outlined,
              required: true,
            ),
            _formField(
              _emailCtrl,
              'Email',
              Icons.email_outlined,
              required: true,
            ),
            _formField(
              _addressCtrl,
              'Street Address',
              Icons.home_outlined,
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _formField(
                    _cityCtrl,
                    'City',
                    Icons.location_city_outlined,
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _formField(
                    _zipCtrl,
                    'ZIP Code',
                    Icons.local_post_office_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: GoldButton(
                label: 'Continue to Payment',
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _step = 1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _formField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: required
            ? (v) => (v == null || v.isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _buildPaymentStep() {
    final methods = [
      {
        'id': 'cod',
        'label': 'Cash on Delivery',
        'icon': Icons.money_outlined,
        'desc': 'Pay when your watch arrives',
      },
      {
        'id': 'online',
        'label': 'Online Payment',
        'icon': Icons.credit_card_outlined,
        'desc': 'Secure payment via card or bank',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...methods.map((m) {
            final sel = _paymentMethod == m['id'];
            return GestureDetector(
              onTap: () => setState(() => _paymentMethod = m['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sel
                      ? AppColors.gold.withOpacity(0.08)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? AppColors.gold : AppColors.border,
                    width: sel ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      m['icon'] as IconData,
                      color: sel ? AppColors.gold : AppColors.silver,
                      size: 28,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['label'] as String,
                            style: TextStyle(
                              color: sel
                                  ? AppColors.gold
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            m['desc'] as String,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      sel
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: sel ? AppColors.gold : AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GoldButton(
                  label: 'Back',
                  outline: true,
                  icon: Icons.arrow_back,
                  onPressed: () => setState(() => _step = 0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GoldButton(
                  label: 'Review Order',
                  icon: Icons.arrow_forward,
                  onPressed: () => setState(() => _step = 2),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildReviewStep() {
    final cart = context.watch<CartProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Your Order',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          // Delivery to
          _infoCard('Delivery Address', Icons.home_outlined, [
            _nameCtrl.text,
            _addressCtrl.text,
            _cityCtrl.text,
            _phoneCtrl.text,
          ]),
          const SizedBox(height: 12),
          _infoCard('Payment Method', Icons.payment_outlined, [
            _paymentMethod == 'cod' ? 'Cash on Delivery' : 'Online Payment',
          ]),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GoldButton(
                  label: 'Back',
                  outline: true,
                  icon: Icons.arrow_back,
                  onPressed: () => setState(() => _step = 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GoldButton(
                  label: 'Place Order',
                  icon: Icons.check_circle_outline,
                  isLoading: _isPlacing,
                  onPressed: () => _placeOrder(cart),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _infoCard(String title, IconData icon, List<String> lines) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ...lines
                  .where((l) => l.isNotEmpty)
                  .map(
                    (l) => Text(
                      l,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...cart.items.values.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.watch.name} x${item.quantity}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Rs ${_formatPrice(item.totalPrice)}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Text(
                'Rs ${_formatPrice(cart.total)}',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(CartProvider cart) async {
    setState(() => _isPlacing = true);
    final auth = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final order = OrderModel(
      id: const Uuid().v4(),
      userId: auth.user?.id ?? 'guest',
      items: cart.toOrderItems(),
      totalAmount: cart.total,
      shippingAddress: {
        'name': _nameCtrl.text,
        'phone': _phoneCtrl.text,
        'email': _emailCtrl.text,
        'address': _addressCtrl.text,
        'city': _cityCtrl.text,
        'zip': _zipCtrl.text,
      },
      paymentMethod: _paymentMethod,
      createdAt: DateTime.now(),
    );
    await orderProvider.placeOrder(order);
    cart.clearCart();
    if (mounted) {
      setState(() => _isPlacing = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ).animate().scale(begin: const Offset(0.5, 0.5)).fadeIn(),
              const SizedBox(height: 16),
              const Text(
                'Order Placed!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your watch is on its way. Thank you for shopping with Watch Hub!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              GoldButton(
                label: 'Continue Shopping',
                icon: Icons.shopping_bag_outlined,
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/');
                },
              ),
            ],
          ),
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
