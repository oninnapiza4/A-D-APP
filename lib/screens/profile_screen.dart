import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/concierge_fab.dart';
import 'role_selector_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  static const String _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuChddCxUAQ4ZKAbj6jJW55cHefcDlWi7iBTpbvd8GTW9LW_Co-kwax1MRRhe4fOJyb_OaC6TB0Ob-fZyMnfLnvCO08vK3spFV0hQ65EuGDxhy2Bl2JFKKxNav-jscrhiChZeOZpWZy3Cm-u4JYPcN8g4ETBQ7sxBhdUEBfqJkHSMYfxs-WmSq5fmHJjhcxAcuum-MX8FoIlerW1yXEd3wtextVNqrIRum-dreIoeMsahKcdAOgAaMsAcw';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: ConciergeFab(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile card
            _buildProfileCard(),
            const SizedBox(height: 16),

            // Quick stats
            _buildQuickStats(),
            const SizedBox(height: 16),

            // Settings menu
            _buildSettingsMenu(),
            const SizedBox(height: 16),

            // Log out button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _confirmLogout,
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Log Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                      color: AppColors.errorContainer.withOpacity(0.3)),
                  backgroundColor:
                      AppColors.errorContainer.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: AppText.labelLg
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Version
            Center(
              child: Column(
                children: [
                  Text('A&D Thysia Resort App v1.0.0',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.outline, letterSpacing: 0.8)),
                  const SizedBox(height: 4),
                  Text('Sta. Cruz, Laguna, Philippines',
                      style: AppText.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant
                              .withOpacity(0.7))),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 16),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _avatarUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.surfaceContainer,
                      child: const Icon(Icons.person,
                          size: 32, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(Icons.verified,
                      size: 13, color: AppColors.onPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Juan Dela Cruz',
                    style: AppText.headlineSm
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('juan.delacruz@gmail.com',
                    style: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant)),
                Text('+63 917 123 4567',
                    style: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLowest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.hotel_class,
                          size: 12, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text('Member since 2024',
                          style: AppText.labelSm.copyWith(
                              color: AppColors.secondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Edit Profile',
                        style: AppText.bodySm),
                    backgroundColor: AppColors.surfaceHigh),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainer,
              ),
              child: const Icon(Icons.edit,
                  size: 20, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _statChip('3', 'Total\nBookings'),
        const SizedBox(width: 8),
        _statChip('2', 'Completed'),
        const SizedBox(width: 8),
        _statChip('4', 'Saved\nRetreats'),
      ],
    );
  }

  Widget _statChip(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: AppText.headlineMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(label,
                style: AppText.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.badge,
            iconColor: AppColors.primary,
            title: 'Personal Information',
            subtitle: 'Name, mobile, emergency contacts',
            onTap: () => _showSnackbar('Personal Information'),
          ),
          _divider(),
          _menuItem(
            icon: Icons.account_balance_wallet,
            iconColor: AppColors.secondary,
            title: 'Payment & Cards',
            subtitle: 'GCash, Maya, cards on file',
            onTap: () => _showSnackbar('Payment & Cards'),
          ),
          _divider(),
          _menuItem(
            icon: Icons.receipt_long,
            iconColor: AppColors.tertiary,
            title: 'Booking History & Receipts',
            subtitle: 'Invoices and electronic check-out folios',
            onTap: () => _showSnackbar('Booking History'),
          ),
          _divider(),
          // Toggle item
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.surfaceHigh,
                  ),
                  child: const Icon(Icons.notifications_active,
                      size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notifications',
                          style: AppText.bodyLg
                              .copyWith(fontWeight: FontWeight.w500)),
                      Text('SMS alerts & booking itinerary reminders',
                          style: AppText.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                // Toggle
                GestureDetector(
                  onTap: () => setState(
                      () => _notificationsEnabled = !_notificationsEnabled),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _notificationsEnabled
                          ? AppColors.primaryContainer
                          : AppColors.surfaceHighest,
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: _notificationsEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.onPrimary,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26, blurRadius: 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _divider(),
          _menuItem(
            icon: Icons.support_agent,
            iconColor: AppColors.secondary,
            title: 'Help & Resort Concierge',
            subtitle: 'Direct chat with Laguna front desk',
            onTap: () => _showSnackbar('Concierge Chat'),
          ),
          _divider(),
          _menuItem(
            icon: Icons.policy,
            iconColor: AppColors.onSurfaceVariant,
            title: 'Resort Guidelines & Terms',
            subtitle: 'Pool rules, quiet hours & pet policy',
            onTap: () => _showSnackbar('Resort Guidelines'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14))
          : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.surfaceHigh,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.bodyLg
                          .copyWith(fontWeight: FontWeight.w500)),
                  Text(subtitle,
                      style: AppText.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.outline),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Divider(
      height: 0,
      thickness: 1,
      color: AppColors.surfaceHighest,
      indent: 16,
      endIndent: 16);

  void _showSnackbar(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label, style: AppText.bodySm),
        backgroundColor: AppColors.surfaceHigh,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Out',
            style: AppText.headlineSm.copyWith(fontWeight: FontWeight.w600)),
        content: Text('Are you sure you want to log out?',
            style: AppText.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel',
                style: AppText.labelLg
                    .copyWith(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => const RoleSelectorScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorContainer.withOpacity(0.6),
              foregroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Log Out',
                style: AppText.labelLg.copyWith(
                    color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
