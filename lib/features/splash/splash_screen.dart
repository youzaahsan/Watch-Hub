// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3800), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Cinematic background image zoom
          Image.network(
                'https://images.unsplash.com/photo-1547996160-81dfa63595aa?w=1400',
                fit: BoxFit.cover,
              )
              .animate()
              .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(1.15, 1.15),
                end: const Offset(1.0, 1.0),
                duration: 4000.ms,
                curve: Curves.easeOutCubic,
              ),

          // Dark overlay for contrast
          Container(
            color: AppColors.bg.withOpacity(0.85),
          ).animate().fadeIn(duration: 800.ms),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Icon
                Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold, width: 1.5),
                        gradient: RadialGradient(
                          colors: [
                            AppColors.gold.withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.watch,
                        color: AppColors.gold,
                        size: 48,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 1000.ms)
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutBack,
                      duration: 1200.ms,
                    ),
                const SizedBox(height: 32),

                // Brand Name
                ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.goldGradient.createShader(bounds),
                      child: const Text(
                        'WATCH HUB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 8,
                        ),
                      ),
                    )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: 12),

                // Tagline
                const Text(
                      'EXCEPTIONAL TIMEPIECES',
                      style: TextStyle(
                        color: AppColors.silver,
                        fontSize: 14,
                        letterSpacing: 6,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                    .animate(delay: 1100.ms)
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 60),

                // Elegant loading line
                SizedBox(
                  width: 120,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.border.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.gold,
                    ),
                  ),
                ).animate(delay: 1500.ms).fadeIn(duration: 800.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
