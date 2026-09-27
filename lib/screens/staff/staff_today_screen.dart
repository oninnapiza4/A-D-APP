import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'staff_rfid_screen.dart';

class StaffTodayScreen extends StatefulWidget {
  final StaffMember staff;
  const StaffTodayScreen({super.key, required this.staff});

  @override
  State<StaffTodayScreen> createState() => _StaffTodayScreenState();
}

class _StaffTodayScreenState extends State<StaffTodayScreen> {
  final List<_Duty> _duties = [
    _Duty('Welcome early arrivals', '8:00 AM', true),
    _Duty('Confirm pavilion setup', '2:30 PM', true),
    _Duty('Close front desk register', '4:45 PM', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF00120B),
        gradient: RadialGradient(
          center: Alignment(0.85, -0.88),
          radius: 0.9,
          colors: [Color(0x721A4E38), Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildShiftCard(),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                    const SizedBox(height: 16),
                    _buildDuties(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('08:44',
              style: AppText.bodyLg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD1FAE5).withOpacity(0.9),
                  fontSize: 15)),
          Container(
            width: 96,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.signal_cellular_alt,
                  size: 14, color: Color(0xFFD1FAE5)),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, size: 14, color: Color(0xFFD1FAE5)),
              const SizedBox(width: 4),
              const Icon(Icons.battery_full,
                  size: 16, color: Color(0xFFD1FAE5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(width: 6),
                Text('WEDNESDAY, 23 SEPTEMBER 2026',
                    style: AppText.labelSm.copyWith(
                        color: const Color(0xFFD4AF37).withOpacity(0.9),
                        letterSpacing: 1.5,
                        fontSize: 10)),
              ],
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: AppText.headlineMd
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 24),
                children: [
                  const TextSpan(
                      text: 'Welcome back, ',
                      style: TextStyle(color: Colors.white)),
                  TextSpan(
                    text: widget.staff.name.split(' ').first,
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(
                      text: '.', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.staff.rfidCode} • ${widget.staff.role}',
              style: AppText.labelSm.copyWith(
                  color: const Color(0xFF34D399).withOpacity(0.7),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        // Avatar
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD4AF37),
                Color(0xFF997B20),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.25),
                blurRadius: 20,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF052A1C),
              border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.4)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(widget.staff.initials,
                      style: AppText.labelLg.copyWith(
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4ECCA3),
                      border: Border.all(
                          color: const Color(0xFF00140D), width: 2),
                    ),
                    child: const Icon(Icons.check,
                        size: 8, color: Color(0xFF00140D)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShiftCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF052A1C), Color(0xFF041C13)],
        ),
        border: Border.all(
            color: const Color(0xFF124E38).withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF062318).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF124E38)),
                    ),
                    child: const Icon(Icons.wb_sunny_outlined,
                        size: 16, color: Color(0xFFD4AF37)),
                  ),
                  const SizedBox(width: 8),
                  Text('YOUR ACTIVE SHIFT',
                      style: AppText.labelSm.copyWith(
                          color: const Color(0xFFD1FAE5).withOpacity(0.8),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              _onTimePill(),
            ],
          ),
          const SizedBox(height: 16),
          // Time range
          Row(
            children: [
              Text('08:00 AM',
                  style: AppText.headlineMd.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('—',
                    style: AppText.headlineMd.copyWith(
                        color: const Color(0xFFD4AF37).withOpacity(0.7),
                        fontSize: 20)),
              ),
              Text('05:00 PM',
                  style: AppText.headlineMd.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: Color(0xFFD4AF37)),
              const SizedBox(width: 4),
              Text('Front Desk • Main Resort Pavilion',
                  style: AppText.bodySm.copyWith(
                      color: const Color(0xFF6EE7B7).withOpacity(0.7))),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF062318).withOpacity(0.9),
                    border: Border.all(
                        color: const Color(0xFF124E38).withOpacity(0.6)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.64,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF997B20),
                            Color(0xFFD4AF37),
                            Color(0xFFFDE68A),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5h 44m elapsed',
                      style: AppText.labelSm.copyWith(
                          color: const Color(0xFFF3E5AB).withOpacity(0.9),
                          fontWeight: FontWeight.w600)),
                  Text('3h 15m remaining',
                      style: AppText.labelSm.copyWith(
                          color: const Color(0xFF6EE7B7)
                              .withOpacity(0.75))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('QUICK ACTIONS',
            style: AppText.labelSm.copyWith(
                color: const Color(0xFF34D399).withOpacity(0.8),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _actionCard(
                Icons.access_time,
                'Clock Out',
                'End shift',
                onTap: () => _showSnack('Clock Out'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionCard(
                Icons.assignment,
                'Handover',
                'Leave notes',
                onTap: () => _showSnack('Handover'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionCard(
                Icons.credit_card,
                'Payroll',
                'Earnings',
                onTap: () => _showSnack('Payroll'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, String sub,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF052A1C), Color(0xFF041D14)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF124E38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFFD4AF37)),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: AppText.labelMd.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            Text(sub,
                style: AppText.labelSm.copyWith(
                    color: const Color(0xFF34D399).withOpacity(0.6),
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildDuties() {
    final done = _duties.where((d) => d.done).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Today's Duties",
                style: AppText.bodyLg.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.white)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF052A1C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Text('$done/${_duties.length} done',
                  style: AppText.labelSm.copyWith(
                      color: const Color(0xFFF3E5AB),
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF052A1C).withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xFF124E38).withOpacity(0.8)),
          ),
          child: Column(
            children: List.generate(_duties.length, (i) {
              final d = _duties[i];
              final isLast = i == _duties.length - 1;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _duties[i] = _Duty(
                            d.label, d.time, !d.done)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: (!d.done)
                            ? const Color(0xFF10B981).withOpacity(0.04)
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  color: d.done
                                      ? const Color(0xFF4ECCA3)
                                          .withOpacity(0.2)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: d.done
                                        ? const Color(0xFF4ECCA3)
                                            .withOpacity(0.6)
                                        : const Color(0xFFD4AF37)
                                            .withOpacity(0.6),
                                    width: d.done ? 1 : 2,
                                  ),
                                ),
                                child: d.done
                                    ? const Icon(Icons.check,
                                        size: 14,
                                        color: Color(0xFF4ECCA3))
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                d.label,
                                style: AppText.bodyMd.copyWith(
                                  color: d.done
                                      ? const Color(0xFF6EE7B7)
                                          .withOpacity(0.5)
                                      : Colors.white,
                                  decoration: d.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontWeight: d.done
                                      ? FontWeight.w400
                                      : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(d.time,
                              style: AppText.labelSm.copyWith(
                                  color: d.done
                                      ? const Color(0xFF34D399)
                                          .withOpacity(0.5)
                                      : const Color(0xFFF3E5AB),
                                  fontWeight: d.done
                                      ? FontWeight.w400
                                      : FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 0,
                      thickness: 1,
                      color:
                          const Color(0xFF124E38).withOpacity(0.4),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _onTimePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF4ECCA3).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF4ECCA3).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFF4ECCA3)),
          ),
          const SizedBox(width: 5),
          Text('ON TIME',
              style: AppText.labelSm.copyWith(
                  color: const Color(0xFF4ECCA3),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(msg, style: AppText.bodySm),
          backgroundColor: AppColors.surfaceHigh,
          duration: const Duration(seconds: 1)),
    );
  }
}

class _Duty {
  final String label;
  final String time;
  final bool done;
  const _Duty(this.label, this.time, this.done);
}
