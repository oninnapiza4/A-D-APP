import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_theme.dart';
import 'staff_shell.dart';

// ─── Staff member model ───────────────────────────────────────────────────────
class StaffMember {
  final String initials;
  final String name;
  final String rfidCode;
  final String role;
  const StaffMember(this.initials, this.name, this.rfidCode, this.role);
}

const _staffList = [
  StaffMember('AS', 'Alex Santos',    'RFID-001', 'Front Desk'),
  StaffMember('CM', 'Carla Mendoza',  'RFID-002', 'Concierge'),
  StaffMember('RT', 'Ramon Torres',   'RFID-003', 'F&B Supervisor'),
  StaffMember('EP', 'Elena Pascual',  'RFID-004', 'Operations'),
  StaffMember('RF', 'Ricky Flores',   'RFID-005', 'Security'),
];

// ─── RFID Access Screen ───────────────────────────────────────────────────────
class StaffRfidScreen extends StatefulWidget {
  const StaffRfidScreen({super.key});

  @override
  State<StaffRfidScreen> createState() => _StaffRfidScreenState();
}

class _StaffRfidScreenState extends State<StaffRfidScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _wave1Ctrl;
  late AnimationController _wave2Ctrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _wave1Anim;
  late Animation<double> _wave2Anim;

  bool _scanning = false;
  String _feedbackText = '';
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _wave1Ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat();
    _wave1Anim = Tween<double>(begin: 0.95, end: 1.4)
        .animate(CurvedAnimation(parent: _wave1Ctrl, curve: Curves.easeOut));

    _wave2Ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat();
    _wave2Anim = Tween<double>(begin: 0.95, end: 1.4)
        .animate(CurvedAnimation(parent: _wave2Ctrl, curve: Curves.easeOut));

    // Offset wave 2 by ~900ms
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _wave2Ctrl.forward();
    });

    // Auto-show bottom sheet after short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _showStaffSheet();
      });
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _wave1Ctrl.dispose();
    _wave2Ctrl.dispose();
    super.dispose();
  }

  void _simulateScan() async {
    setState(() {
      _scanning = true;
      _feedbackText = 'Verifying RFID Token #THY-8842...';
      _showFeedback = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _feedbackText = '✓ Welcome, Front Desk Lead! Access Granted.';
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _showStaffSheet();
  }

  void _showStaffSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => _StaffSelectionSheet(
        onSelect: (staff) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => StaffShell(staff: staff),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00170E),
      body: Stack(
        children: [
          // Mesh glow background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.7),
                  radius: 1.2,
                  colors: [
                    Color(0x2910B981),
                    Color(0xFF00170E),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, 1),
                  radius: 1.0,
                  colors: [Color(0x14D4AF37), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Brand header
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: Column(
                    children: [
                      // Logo badge with pulse pip
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFD4AF37),
                                  Color(0xFF10B981),
                                  Color(0xFF0F3827),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF052016)
                                      .withOpacity(0.8),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://lh3.googleusercontent.com/aida/AEtjO1XUFbWkKajb9OxxDYc-1ukc5u8vD9clwc8MvM4_57mdYw0Ym4YYV11Bfcuv1l85YrjIVbnnle6bIJKcHVoKtljku6a1IumsZW0flLUOZtO387q3YZD67Rf4u9SkmwdetlZKjBCBEfA0nFepL5o-RUtfB6rbbsVw7_R_mn7gP-5s8lS_Slb6YYgNXav8u1wrRJvW5Dm6e2F2OgoBzxk5SE7YDR3b5WnDR3fwlZHhAg9TZVkRmIOaa--kKx0v',
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  color: const Color(0xFF0A2E20),
                                  child: const Center(
                                    child: Text('A&D',
                                        style: TextStyle(
                                            color: Color(0xFFFFB95F),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Ping pip
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0x7834D399),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF10B981),
                                        border: Border.all(
                                            color: const Color(0xFF00170E),
                                            width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'STAFF ACCESS TERMINAL',
                        style: AppText.labelSm.copyWith(
                            color: const Color(0xFF34D399).withOpacity(0.9),
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "A&D Thysia Resort & Event's Place",
                        style: AppText.bodyMd.copyWith(
                            color: const Color(0xFFD1FAE5).withOpacity(0.9),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      // Shift context pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A2E20).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF1B4D36)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFD4AF37)),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AM Shift • Front Office & Security Station 01',
                              style: AppText.labelSm.copyWith(
                                  color: const Color(0xFFD1FAE5)
                                      .withOpacity(0.8),
                                  fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // RFID scanner target
                      SizedBox(
                        width: 168,
                        height: 168,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Wave ring 1
                            AnimatedBuilder(
                              animation: _wave1Anim,
                              builder: (_, __) => Transform.scale(
                                scale: _wave1Anim.value,
                                child: Container(
                                  width: 152,
                                  height: 152,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF34D399)
                                          .withOpacity(0.3 *
                                              (1.4 - _wave1Anim.value) /
                                              0.45),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Wave ring 2
                            AnimatedBuilder(
                              animation: _wave2Anim,
                              builder: (_, __) => Transform.scale(
                                scale: _wave2Anim.value,
                                child: Container(
                                  width: 152,
                                  height: 152,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF34D399)
                                          .withOpacity(0.2 *
                                              (1.4 - _wave2Anim.value) /
                                              0.45),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Outer pulsing ring
                            AnimatedBuilder(
                              animation: _pulseAnim,
                              builder: (_, child) => Transform.scale(
                                scale: _pulseAnim.value,
                                child: child,
                              ),
                              child: Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFF34D399)
                                          .withOpacity(0.4)),
                                  color: const Color(0xFF0A2E20)
                                      .withOpacity(0.6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981)
                                          .withOpacity(0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF164E37),
                                        Color(0xFF082B1C),
                                      ],
                                    ),
                                    border: Border.all(
                                        color: const Color(0xFF34D399)
                                            .withOpacity(0.5)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.bolt,
                                        size: 36,
                                        color: const Color(0xFF34D399),
                                        shadows: [
                                          Shadow(
                                            color: const Color(0xFF34D399)
                                                .withOpacity(0.6),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _dot(),
                                          const SizedBox(width: 4),
                                          _wideBar(),
                                          const SizedBox(width: 4),
                                          _dot(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tap your RFID Card',
                        style: AppText.headlineSm.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap your assigned card or badge on reader\nto access your staff duty dashboard.',
                        style: AppText.bodySm.copyWith(
                          color: const Color(0xFFD1FAE5).withOpacity(0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // NFC status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00170E).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF34D399)
                                  .withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PulsingDot(color: const Color(0xFF34D399)),
                            const SizedBox(width: 6),
                            Text(
                              'Sensor Ready • Hold card near top back',
                              style: AppText.labelSm.copyWith(
                                  color: const Color(0xFF34D399),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      // Feedback area
                      if (_showFeedback) ...[
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          decoration: BoxDecoration(
                            color: const Color(0xFF062318).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFF34D399)
                                    .withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_scanning)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF34D399),
                                    strokeWidth: 2,
                                  ),
                                ),
                              if (_scanning) const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _feedbackText,
                                  style: AppText.labelSm.copyWith(
                                      color: const Color(0xFF34D399),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Quick actions
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      // Simulate button
                      GestureDetector(
                        onTap: _simulateScan,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF10B981),
                                Color(0xFF059669),
                                Color(0xFF047857),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFF34D399)
                                    .withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF064E3B)
                                    .withOpacity(0.6),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.wifi_tethering,
                                  size: 20, color: Color(0xFF00170E)),
                              const SizedBox(width: 8),
                              Text(
                                'Simulate RFID Tap / Clock In',
                                style: AppText.labelLg.copyWith(
                                    color: const Color(0xFF00170E),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Shift stats
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF052016)
                                    .withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFF1B4D36)
                                        .withOpacity(0.6)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('ACTIVE BOOKINGS',
                                      style: AppText.labelSm.copyWith(
                                          color: const Color(0xFF6EE7B7)
                                              .withOpacity(0.6),
                                          letterSpacing: 0.8)),
                                  const SizedBox(height: 2),
                                  Text('24 Checked-In',
                                      style: AppText.labelLg.copyWith(
                                          color: const Color(0xFFD4AF37),
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF052016)
                                    .withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFF1B4D36)
                                        .withOpacity(0.6)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('TERMINAL MODE',
                                      style: AppText.labelSm.copyWith(
                                          color: const Color(0xFF6EE7B7)
                                              .withOpacity(0.6),
                                          letterSpacing: 0.8)),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF34D399),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text('Live Sync',
                                          style: AppText.labelLg.copyWith(
                                              color: const Color(0xFFD1FAE5),
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        'Having trouble? Contact Resort Supervisor or Admin',
                        style: AppText.labelSm.copyWith(
                            color: const Color(0xFF6EE7B7)
                                .withOpacity(0.5)),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back,
                                size: 14,
                                color: Color(0xFF6EE7B7)),
                            const SizedBox(width: 4),
                            Text(
                              'Back to Home / Role Selector',
                              style: AppText.labelSm.copyWith(
                                  color: const Color(0xFF6EE7B7)
                                      .withOpacity(0.8),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
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

  Widget _dot() => Container(
      width: 4, height: 4,
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: Color(0xFF34D399)));

  Widget _wideBar() => Container(
      width: 12, height: 4,
      decoration: BoxDecoration(
          color: const Color(0xFF34D399).withOpacity(0.7),
          borderRadius: BorderRadius.circular(2)));
}

// ─── Staff Selection Bottom Sheet ─────────────────────────────────────────────
class _StaffSelectionSheet extends StatelessWidget {
  final ValueChanged<StaffMember> onSelect;
  const _StaffSelectionSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.66,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF09241A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 40,
            offset: Offset(0, -15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF144E38).withOpacity(0.6),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 16),
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select staff member',
                        style: AppText.headlineSm.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('RFID reader detected 5 active profiles',
                        style: AppText.bodySm.copyWith(
                            color: const Color(0xFF6EE7B7)
                                .withOpacity(0.8))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF203A2F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFFFB95F).withOpacity(0.3)),
                  ),
                  child: Text('Ready to tap',
                      style: AppText.labelSm.copyWith(
                          color: const Color(0xFFFFB95F),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Staff list
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shrinkWrap: true,
              itemCount: _staffList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final s = _staffList[i];
                return _StaffItem(
                  staff: s,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelect(s);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Home indicator
          Container(
            width: 128,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF144E38).withOpacity(0.8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _StaffItem extends StatelessWidget {
  final StaffMember staff;
  final VoidCallback onTap;
  const _StaffItem({required this.staff, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF052016).withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF10B981), Color(0xFF00422B)],
                ),
                border: Border.all(
                    color: const Color(0xFF6EE7B7).withOpacity(0.3)),
              ),
              child: Center(
                child: Text(staff.initials,
                    style: AppText.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(staff.name,
                      style: AppText.bodyLg.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF203A2F),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(staff.rfidCode,
                            style: AppText.labelSm.copyWith(
                                color: const Color(0xFF34D399),
                                fontFamily: 'monospace',
                                fontSize: 11)),
                      ),
                      const SizedBox(width: 6),
                      Text(staff.role,
                          style: AppText.bodySm.copyWith(
                              color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20,
                color: Color(0xFF34D399)),
          ],
        ),
      ),
    );
  }
}

// ─── Pulsing dot widget ───────────────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withOpacity(_anim.value),
        ),
      ),
    );
  }
}
