import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/resort_app_bar.dart';
import '../utils/booking_nav.dart';
import 'home_screen.dart';
import 'my_bookings_screen.dart';
import 'profile_screen.dart';

/// Main shell used after successful sign-in.
/// Hosts the bottom-nav between Home, My Bookings, and Profile.
class MainGuestShell extends StatefulWidget {
  const MainGuestShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainGuestShell> createState() => _MainGuestShellState();
}

class _MainGuestShellState extends State<MainGuestShell> {
  late int _navIndex;

  @override
  void initState() {
    super.initState();
    _navIndex = widget.initialIndex;
  }

  // Individual tab title/subtitle for AppBar
  static const _tabTitles = [
    ('Home', 'A&D Thysia'),
    ('My Bookings', 'A&D Thysia Resort'),
    ('Profile', 'A&D Thysia'),
  ];

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = _tabTitles[_navIndex];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ResortAppBar(
        title: title,
        subtitle: subtitle,
        showBookNow: _navIndex == 0,
        onBookNow: () => navigateToBooking(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _navIndex,
        children: const [
          HomeScreen(standalone: false),
          MyBookingsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      _NavItem(Icons.villa, 'Book'),
      _NavItem(Icons.event_available, 'My Bookings'),
      _NavItem(Icons.account_circle, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (i) => GestureDetector(
                onTap: () => setState(() => _navIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].icon,
                        size: 24,
                        color: _navIndex == i
                            ? (_navIndex == 1
                                ? AppColors.secondary
                                : AppColors.primary)
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].label,
                        style: AppText.labelSm.copyWith(
                          color: _navIndex == i
                              ? (_navIndex == 1
                                  ? AppColors.secondary
                                  : AppColors.primary)
                              : AppColors.onSurfaceVariant,
                          fontWeight: _navIndex == i
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);
}
