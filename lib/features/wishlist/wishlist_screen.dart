// lib/features/wishlist/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/app_nav_bar.dart';
import '../../widgets/watch_card.dart';
import '../../widgets/gold_button.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;
    final watches = wishlist.items.values.toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppNavBar(),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wishlist (${watches.length})',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            if (watches.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: AppColors.textMuted,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your wishlist is empty',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Save your favorite watches here',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 24),
                      GoldButton(
                        label: 'Browse Watches',
                        icon: Icons.watch,
                        onPressed: () => context.push('/shop'),
                      ),
                    ],
                  ).animate().fadeIn(),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 4 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: MediaQuery.of(context).size.width < 450
                        ? 0.47
                        : 0.65,
                  ),
                  itemCount: watches.length,
                  itemBuilder: (_, i) => WatchCard(
                    watch: watches[i],
                  ).animate(delay: (i * 80).ms).fadeIn(duration: 300.ms),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
