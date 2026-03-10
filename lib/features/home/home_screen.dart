// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../models/watch_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/watch_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/gold_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Timeless Elegance',
      'subtitle': 'Discover our exclusive collection of luxury timepieces',
      'cta': 'Shop Now',
      'image':
          'https://images.unsplash.com/photo-1547996160-81dfa63595aa?w=1400',
      'badge': 'NEW ARRIVALS',
    },
    {
      'title': 'Swiss Precision',
      'subtitle': 'From Rolex to Patek Philippe – Own the finest',
      'cta': 'Explore',
      'image':
          'https://images.unsplash.com/photo-1587836374828-4dbafa94cf0e?w=1400',
      'badge': 'BEST SELLERS',
    },
    {
      'title': 'Smart Luxury',
      'subtitle': 'Where technology meets elegance',
      'cta': 'View Collection',
      'image':
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=1400',
      'badge': 'SMART WATCHES',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': "Men's",
      'icon': Icons.man_outlined,
      'color': const Color(0xFF1F4068),
    },
    {
      'name': "Women's",
      'icon': Icons.woman_outlined,
      'color': const Color(0xFF6B2D5E),
    },
    {
      'name': 'Smart',
      'icon': Icons.watch_later_outlined,
      'color': const Color(0xFF1A5276),
    },
    {
      'name': 'Luxury',
      'icon': Icons.diamond_outlined,
      'color': const Color(0xFF6E2C0E),
    },
    {
      'name': 'Casual',
      'icon': Icons.watch_outlined,
      'color': const Color(0xFF145A32),
    },
    {
      'name': 'Sport',
      'icon': Icons.sports_volleyball_outlined,
      'color': const Color(0xFF4A235A),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadWatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppNavBar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            _buildHeroBanner(isWide),
            // Categories
            _buildCategoriesSection(),
            // Featured Watches
            if (products.featuredWatches.isNotEmpty)
              _buildWatchSection(
                title: 'Featured Watches',
                subtitle: 'Handpicked masterpieces',
                watches: products.featuredWatches,
                viewAllRoute: '/shop',
              ),
            // Watch of the Month
            _buildWatchOfMonth(products),
            // Best Sellers
            if (products.bestSellers.isNotEmpty)
              _buildWatchSection(
                title: 'Best Sellers',
                subtitle: 'Most loved by our customers',
                watches: products.bestSellers,
                viewAllRoute: '/shop',
              ),
            // New Arrivals
            if (products.newArrivals.isNotEmpty)
              _buildWatchSection(
                title: 'New Arrivals',
                subtitle: 'Fresh from the watchmakers',
                watches: products.newArrivals,
                viewAllRoute: '/shop',
              ),
            // Sale
            if (products.onSale.isNotEmpty)
              _buildWatchSection(
                title: 'Discount Offers',
                subtitle: 'Limited time deals',
                watches: products.onSale,
                viewAllRoute: '/shop',
                showSale: true,
              ),
            // Testimonials
            _buildTestimonials(),
            // Newsletter
            _buildNewsletter(),
            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(bool isWide) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: isWide ? 560 : 400,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, _) => setState(() => _currentBanner = index),
          ),
          items: _banners.map((banner) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: banner['image'],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.surface),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.transparent,
                        AppColors.bg.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 80 : 28,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.gold,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              banner['badge'],
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms)
                          .slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 18),
                      Text(
                            banner['title'],
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: isWide ? 56 : 36,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 350.ms, duration: 500.ms)
                          .slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 14),
                      Text(
                        banner['subtitle'],
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: isWide ? 18 : 14,
                        ),
                      ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
                      const SizedBox(height: 30),
                      GoldButton(
                            label: banner['cta'],
                            onPressed: () => context.push('/shop'),
                            icon: Icons.arrow_forward,
                          )
                          .animate()
                          .fadeIn(delay: 650.ms, duration: 400.ms)
                          .slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentBanner,
              count: _banners.length,
              effect: const WormEffect(
                dotColor: AppColors.border,
                activeDotColor: AppColors.gold,
                dotHeight: 6,
                dotWidth: 6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Categories',
            subtitle: 'Find your perfect match',
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.asMap().entries.map((entry) {
                final i = entry.key;
                final cat = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => context.push('/shop?category=${cat['name']}'),
                    child:
                        Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (cat['color'] as Color).withOpacity(
                                      0.15,
                                    ),
                                    border: Border.all(
                                      color: (cat['color'] as Color)
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  child: Icon(
                                    cat['icon'] as IconData,
                                    color: AppColors.gold,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cat['name'] as String,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                            .animate(delay: (i * 80).ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.3, end: 0),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchSection({
    required String title,
    required String subtitle,
    required List watches,
    required String viewAllRoute,
    bool showSale = false,
  }) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final crossAxisCount = isWide ? 4 : 2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            onViewAll: () => context.push(viewAllRoute),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: MediaQuery.of(context).size.width < 450
                  ? 0.47
                  : 0.65,
            ),
            itemCount: watches.length > (isWide ? 4 : 4)
                ? (isWide ? 4 : 4)
                : watches.length,
            itemBuilder: (ctx, i) => WatchCard(watch: watches[i])
                .animate(delay: (i * 100).ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchOfMonth(ProductProvider products) {
    if (products.featuredWatches.isEmpty) return const SizedBox();
    final watch = products.featuredWatches.first;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 48, 24, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1A0A), Color(0xFF0A0A0A), Color(0xFF1C150A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final isWide = constraints.maxWidth > 600;
          return isWide
              ? Row(
                  children: [
                    Expanded(child: _watchOfMonthInfo(watch)),
                    Expanded(child: _watchOfMonthImage(watch)),
                  ],
                )
              : Column(
                  children: [
                    _watchOfMonthImage(watch),
                    _watchOfMonthInfo(watch),
                  ],
                );
        },
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _watchOfMonthInfo(WatchModel watch) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '⭐  WATCH OF THE MONTH',
              style: TextStyle(
                color: AppColors.bg,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            watch.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            watch.brand,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 14,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            watch.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          Text(
            'Rs ${_formatPrice(watch.effectivePrice)}',
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          GoldButton(
            label: 'Shop Now',
            onPressed: () => context.push('/product/${watch.id}'),
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  Widget _watchOfMonthImage(WatchModel watch) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: CachedNetworkImage(
          imageUrl: watch.images.isNotEmpty ? watch.images.first : '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTestimonials() {
    final reviews = [
      {
        'name': 'Ahmed Khan',
        'rating': 5.0,
        'comment':
            'Best watch store I have ever shopped at. The packaging was premium and my Rolex arrived in perfect condition!',
        'watch': 'Rolex Submariner',
      },
      {
        'name': 'Sarah Ali',
        'rating': 5.0,
        'comment':
            'Absolutely in love with my new Omega. Authentic product, fast delivery, and amazing customer support.',
        'watch': 'Omega Speedmaster',
      },
      {
        'name': 'Bilal Raza',
        'rating': 4.5,
        'comment':
            'Great site and excellent selection. The Apple Watch Ultra is a masterpiece. Will shop again!',
        'watch': 'Apple Watch Ultra 2',
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 48, 0, 0),
      padding: const EdgeInsets.symmetric(vertical: 48),
      color: AppColors.surface,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SectionHeader(
              title: 'Customer Reviews',
              subtitle: 'What our clients say',
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: reviews.asMap().entries.map((entry) {
                final i = entry.key;
                final r = entry.value;
                return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (si) => Icon(
                                si < (r['rating'] as double).floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppColors.gold,
                                size: 15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '"${r['comment']}"',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.gold.withOpacity(
                                  0.15,
                                ),
                                child: Text(
                                  (r['name'] as String)[0],
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['name'] as String,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    r['watch'] as String,
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    .animate(delay: (i * 120).ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.2, end: 0);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsletter() {
    final emailCtrl = TextEditingController();
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 48, 24, 0),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C150A), Color(0xFF0A0A0A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          const Icon(Icons.mail_outline, color: AppColors.gold, size: 36),
          const SizedBox(height: 16),
          const Text(
            'Stay in the Loop',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Subscribe to get exclusive offers, new arrivals & luxury watch updates.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GoldButton(
                label: 'Subscribe',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Subscribed successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      padding: const EdgeInsets.all(40),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.watch, color: AppColors.gold, size: 24),
              const SizedBox(width: 8),
              const Text(
                'WATCH HUB',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Your destination for premium timepieces.\nAuthenticity guaranteed on every purchase.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          const Text(
            '© 2026 Watch Hub. All rights reserved.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
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
