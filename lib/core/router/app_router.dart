// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../features/home/home_screen.dart';
import '../../features/shop/shop_screen.dart';
import '../../features/product/product_detail_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/wishlist/wishlist_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/splash',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final path = state.uri.path;
        final protectedRoutes = ['/profile', '/orders', '/checkout', '/admin'];
        final authRoutes = ['/login', '/signup'];

        if (protectedRoutes.any((r) => path.startsWith(r)) && !isLoggedIn) {
          return '/login';
        }
        if (authRoutes.contains(path) && isLoggedIn) {
          return '/';
        }
        if (path.startsWith('/admin') && !authProvider.isAdmin) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) =>
              _buildPage(const SplashScreen(), state),
        ),
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              _buildPage(const HomeScreen(), state),
        ),
        GoRoute(
          path: '/shop',
          pageBuilder: (context, state) => _buildPage(
            ShopScreen(
              category: state.uri.queryParameters['category'],
              brand: state.uri.queryParameters['brand'],
            ),
            state,
          ),
        ),
        GoRoute(
          path: '/product/:id',
          pageBuilder: (context, state) => _buildPage(
            ProductDetailScreen(watchId: state.pathParameters['id']!),
            state,
          ),
        ),
        GoRoute(
          path: '/cart',
          pageBuilder: (context, state) =>
              _buildPage(const CartScreen(), state),
        ),
        GoRoute(
          path: '/checkout',
          pageBuilder: (context, state) =>
              _buildPage(const CheckoutScreen(), state),
        ),
        GoRoute(
          path: '/wishlist',
          pageBuilder: (context, state) =>
              _buildPage(const WishlistScreen(), state),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) =>
              _buildPage(const LoginScreen(), state),
        ),
        GoRoute(
          path: '/signup',
          pageBuilder: (context, state) =>
              _buildPage(const SignupScreen(), state),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              _buildPage(const ProfileScreen(), state),
        ),
        GoRoute(
          path: '/orders',
          pageBuilder: (context, state) =>
              _buildPage(const OrdersScreen(), state),
        ),
        GoRoute(
          path: '/admin',
          pageBuilder: (context, state) =>
              _buildPage(const AdminDashboardScreen(), state),
        ),
      ],
    );
  }

  static CustomTransitionPage _buildPage(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
