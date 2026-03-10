// lib/widgets/app_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class AppNavBar extends StatefulWidget implements PreferredSizeWidget {
  const AppNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  bool _showCategoryDropdown = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;
    final isMedium = MediaQuery.of(context).size.width > 600;

    return Container(
      color: AppColors.bg,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.bg,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 0.5),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 10),
            child: Row(
              children: [
                // Back Button (if not on home screen)
                if (GoRouterState.of(context).uri.toString() != '/')
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.silver,
                      ),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
                      tooltip: 'Back',
                    ),
                  ),
                // Logo
                GestureDetector(
                  onTap: () => context.go('/'),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.goldGradient.createShader(bounds),
                        child: Icon(
                          Icons.watch,
                          color: Colors.white,
                          size: isWide ? 28 : 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (MediaQuery.of(context).size.width > 350)
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.goldGradient.createShader(bounds),
                          child: Text(
                            'WATCH HUB',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: isWide ? 20 : 18,
                              letterSpacing: isWide ? 2 : 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                // Desktop nav links
                if (isWide) ...[
                  _NavLink(label: 'Home', route: '/'),
                  _NavLink(label: 'Shop', route: '/shop'),
                  // Categories dropdown
                  MouseRegion(
                    onEnter: (_) =>
                        setState(() => _showCategoryDropdown = true),
                    onExit: (_) =>
                        setState(() => _showCategoryDropdown = false),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                  color: _showCategoryDropdown
                                      ? AppColors.gold
                                      : AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: _showCategoryDropdown
                                    ? AppColors.gold
                                    : AppColors.textSecondary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        if (_showCategoryDropdown)
                          Positioned(
                            top: 36,
                            left: 0,
                            child: _CategoryDropdown(
                              onClose: () =>
                                  setState(() => _showCategoryDropdown = false),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _NavLink(label: 'About', route: '/'),
                  _NavLink(label: 'Contact', route: '/'),
                  if (auth.isAdmin) _NavLink(label: 'Admin', route: '/admin'),
                ],
                const SizedBox(width: 16),
                // Actions
                // Search
                if (isMedium)
                  IconButton(
                    onPressed: () => _showSearch(context),
                    icon: const Icon(Icons.search, color: AppColors.silver),
                    tooltip: 'Search',
                  ),
                // Wishlist
                IconButton(
                  onPressed: () => context.push('/wishlist'),
                  icon: const Icon(
                    Icons.favorite_border,
                    color: AppColors.silver,
                  ),
                  tooltip: 'Wishlist',
                ),
                // Cart
                Stack(
                  children: [
                    IconButton(
                      onPressed: () => context.push('/cart'),
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.silver,
                      ),
                      tooltip: 'Cart',
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: AppColors.bg,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Profile / Login
                if (auth.isLoggedIn)
                  PopupMenuButton<String>(
                    color: AppColors.card,
                    offset: const Offset(0, 48),
                    padding: EdgeInsets.zero,
                    icon: CircleAvatar(
                      radius: isWide ? 16 : 14,
                      backgroundColor: AppColors.gold.withOpacity(0.15),
                      child: Text(
                        auth.user!.name.isNotEmpty
                            ? auth.user!.name[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: isWide ? 14 : 12,
                        ),
                      ),
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'profile',
                        child: _menuItem(Icons.person_outline, 'Profile'),
                      ),
                      PopupMenuItem(
                        value: 'orders',
                        child: _menuItem(
                          Icons.receipt_long_outlined,
                          'My Orders',
                        ),
                      ),
                      if (auth.isAdmin)
                        PopupMenuItem(
                          value: 'admin',
                          child: _menuItem(
                            Icons.admin_panel_settings_outlined,
                            'Admin Panel',
                          ),
                        ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'logout',
                        child: _menuItem(Icons.logout, 'Logout'),
                      ),
                    ],
                    onSelected: (val) {
                      switch (val) {
                        case 'profile':
                          context.push('/profile');
                          break;
                        case 'orders':
                          context.push('/orders');
                          break;
                        case 'admin':
                          context.push('/admin');
                          break;
                        case 'logout':
                          context.read<AuthProvider>().logout();
                          break;
                      }
                    },
                  )
                else
                  isWide
                      ? TextButton(
                          onPressed: () => context.push('/login'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () => context.push('/login'),
                          icon: const Icon(Icons.login, color: AppColors.gold),
                          tooltip: 'Login',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                if (!isWide)
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: AppColors.silver,
                        size: 24,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
      ],
    );
  }

  void _showSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Search Watches',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search by name, brand...',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (val) {
                  Navigator.pop(context);
                  context.push('/shop?q=$val');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String route;
  const _NavLink({required this.label, required this.route});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          if (widget.route == '/') {
            context.go('/');
          } else {
            context.push(widget.route);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? AppColors.gold : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: _hovered ? 30 : 0,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final VoidCallback onClose;
  const _CategoryDropdown({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final cats = [
      {'label': "Men's Watches", 'icon': Icons.man, 'param': "Men's"},
      {'label': "Women's Watches", 'icon': Icons.woman, 'param': "Women's"},
      {
        'label': 'Smart Watches',
        'icon': Icons.watch_later_outlined,
        'param': 'Smart',
      },
      {'label': 'Luxury', 'icon': Icons.diamond, 'param': 'Luxury'},
      {'label': 'Casual', 'icon': Icons.watch, 'param': 'Casual'},
      {'label': 'Sport', 'icon': Icons.fitness_center, 'param': 'Sport'},
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: cats.map((cat) {
            return InkWell(
              onTap: () {
                onClose();
                context.push('/shop?category=${cat['param']}');
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      color: AppColors.gold,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      cat['label'] as String,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Mobile drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Drawer(
      backgroundColor: AppColors.card,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
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
            ),
            const Divider(color: AppColors.border),
            _drawerItem(context, Icons.home_outlined, 'Home', '/'),
            _drawerItem(context, Icons.store_outlined, 'Shop', '/shop'),
            _drawerItem(
              context,
              Icons.category_outlined,
              'Categories',
              '/shop',
            ),
            _drawerItem(
              context,
              Icons.favorite_border,
              'Wishlist',
              '/wishlist',
            ),
            _drawerItem(context, Icons.shopping_bag_outlined, 'Cart', '/cart'),
            const Divider(color: AppColors.border),
            if (auth.isLoggedIn) ...[
              _drawerItem(context, Icons.person_outline, 'Profile', '/profile'),
              _drawerItem(
                context,
                Icons.receipt_long_outlined,
                'My Orders',
                '/orders',
              ),
              if (auth.isAdmin)
                _drawerItem(
                  context,
                  Icons.admin_panel_settings_outlined,
                  'Admin',
                  '/admin',
                ),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthProvider>().logout();
                },
              ),
            ] else ...[
              _drawerItem(context, Icons.login, 'Login', '/login'),
              _drawerItem(
                context,
                Icons.person_add_outlined,
                'Sign Up',
                '/signup',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.silver),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        if (route == '/') {
          context.go('/');
        } else {
          context.push(route);
        }
      },
    );
  }
}
