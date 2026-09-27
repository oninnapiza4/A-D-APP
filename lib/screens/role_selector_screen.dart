import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'staff_placeholder_screen.dart';

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Ambient glow background
          Positioned(
            top: -60,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.12),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -40,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF10B981).withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          // Palm frond watermark
          Positioned(
            top: -40,
            right: -80,
            child: Opacity(
              opacity: 0.035,
              child: Icon(Icons.eco,
                  size: 320, color: AppColors.primary),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Status-bar-style top row
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('12:40',
                          style: AppText.labelLg.copyWith(
                              fontWeight: FontWeight.w600)),
                      Container(
                        width: 96,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF1B3A28).withOpacity(0.3)),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.signal_cellular_alt,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          const Icon(Icons.wifi,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Container(
                            width: 22,
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 1),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        // Brand header row
                        Row(
                          children: [
                            // Monogram icon
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.goldAccent
                                        .withOpacity(0.4)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://lh3.googleusercontent.com/aida/AEtjO1VN0v8VTYBldPyDxM0th7kaWBgoyAVap4HRVYRjmBEcczxry-G6lFhkvkHosQGOQX8azBdZe1OqqBJjid73kP9iSb4kMWJz8Vpw2VuGkVMRR9eDguTkLl-8knUbGI1pdz1pc9lt6n4Ot4HKEMR3HYsAbjvdo0uTajK6g2njB6NSD6hY-YA8ejMaac_SoJIqnmhOhHtv_zdN8jwFGvky1YOzKsjNbxpTSxD02yrcatSmN8Ywz7AKmDkY2jb-',
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    color: const Color(0xFF092E20),
                                    child: const Center(
                                      child: Text('A',
                                          style: TextStyle(
                                              color: Color(0xFFFFB95F),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Location pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A2A1C).withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.goldAccent
                                        .withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.goldAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'A&D THYSIA RESORT • LAGUNA',
                                    style: AppText.labelSm.copyWith(
                                        color: const Color(0xFFFCD34D),
                                        letterSpacing: 0.8),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Main title
                        Text(
                          'Choose your\nexperience',
                          style: AppText.displayMobile.copyWith(
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Select a role to explore what A&D Thysia Resort's platform can do for you.",
                          style: AppText.bodySm.copyWith(
                            color: AppColors.onSurface.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Guest card
                        _RoleCard(
                          iconWidget: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF047857)
                                ],
                              ),
                              border: Border.all(
                                  color: const Color(0xFF6EE7B7)
                                      .withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF064E3B)
                                      .withOpacity(0.6),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.luggage,
                                color: Colors.white, size: 24),
                          ),
                          title: 'Guest',
                          description:
                              'Reserve facilities, select your preferred payment method, and get instant help from our AI concierge assistant — all before you even arrive.',
                          actionLabel: 'Continue',
                          actionColor: AppColors.primary,
                          borderColor: AppColors.primary.withOpacity(0.3),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Staff card
                        _RoleCard(
                          iconWidget: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFF59E0B),
                                  Color(0xFFB45309)
                                ],
                              ),
                              border: Border.all(
                                  color: const Color(0xFFFDE68A)
                                      .withOpacity(0.4)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF78350F)
                                      .withOpacity(0.6),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.badge,
                                color: Colors.white, size: 24),
                          ),
                          title: 'Staff',
                          description:
                              'Tap in with RFID, complete your shift duties, hand over notes to the next team, and view your payroll — all from one streamlined dashboard.',
                          actionLabel: 'Continue',
                          actionColor: AppColors.secondary,
                          borderColor: AppColors.secondary.withOpacity(0.35),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const StaffPlaceholderScreen()),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Text(
                        "A&D Thysia Resort & Event's Place • Sta. Cruz, Laguna",
                        style: AppText.labelSm.copyWith(
                            color: AppColors.primary.withOpacity(0.7)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 128,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Role Card ────────────────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final Widget iconWidget;
  final String title;
  final String description;
  final String actionLabel;
  final Color actionColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.iconWidget,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.actionColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0B2B1E).withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: widget.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
              const BoxShadow(
                color: Color(0x14FFFFFF),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.iconWidget,
              const SizedBox(height: 16),
              Text(widget.title,
                  style: AppText.headlineSm
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: AppText.bodySm.copyWith(
                  color: const Color(0xFFE2F3EA),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(widget.actionLabel,
                      style: AppText.labelLg.copyWith(
                          color: widget.actionColor,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward,
                      size: 16, color: widget.actionColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
