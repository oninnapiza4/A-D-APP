import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'staff_rfid_screen.dart';

class StaffAttendanceScreen extends StatefulWidget {
  final StaffMember staff;
  const StaffAttendanceScreen({super.key, required this.staff});

  @override
  State<StaffAttendanceScreen> createState() =>
      _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen>
    with SingleTickerProviderStateMixin {
  bool _clockedOut = false;
  String _statusHeading = 'Ready to clock out?';
  String _statusDesc =
      'Tap your RFID card on the reader to end your active shift.';
  String _feedbackMsg = '';
  bool _showFeedback = false;
  bool _rfidBounce = false;

  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _bounceAnim = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _simulateTap() async {
    // Bounce badge
    await _bounceCtrl.forward();
    await _bounceCtrl.reverse();

    setState(() {
      if (!_clockedOut) {
        _clockedOut = true;
        _statusHeading = 'Shift Ended • Clocked Out';
        _statusDesc =
            'RFID scan verified. Have a relaxing evening at Thysia.';
        _feedbackMsg =
            'RFID: Verified at Main Reception Desk 01';
      } else {
        _clockedOut = false;
        _statusHeading = 'Ready to clock out?';
        _statusDesc =
            'Tap your RFID card on the reader to end your active shift.';
        _feedbackMsg = 'Shift started: Welcome back, ${widget.staff.name.split(' ').first}!';
      }
      _showFeedback = true;
    });

    await Future.delayed(const Duration(milliseconds: 3200));
    if (mounted) setState(() => _showFeedback = false);
  }

  static const _history = [
    _AttendRow('Mon, 07 Sep', '8:02 AM — 5:11 PM', '9h 9m', true),
    _AttendRow('Fri, 04 Sep', '8:17 AM — 5:06 PM', '8h 49m', false),
    _AttendRow('Thu, 03 Sep', '7:58 AM — 5:08 PM', '9h 10m', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF00120A),
        gradient: RadialGradient(
          center: Alignment(0.85, -0.88),
          radius: 0.9,
          colors: [Color(0x1810B981), Colors.transparent],
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
                    _buildClockOutCard(),
                    const SizedBox(height: 16),
                    _buildHistorySection(),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('08:44',
              style: AppText.bodyLg.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.onSurface)),
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Row(
            children: [
              Icon(Icons.signal_cellular_alt,
                  size: 16, color: AppColors.onSurface),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 16, color: AppColors.onSurface),
              SizedBox(width: 4),
              Icon(Icons.battery_full,
                  size: 19, color: AppColors.onSurface),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 13, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text('WEDNESDAY, 23 SEPTEMBER 2026',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 1.2)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Shift Attendance',
                  style: AppText.headlineMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.staff.rfidCode} • Active Shift • ',
                    style: AppText.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant),
                  ),
                  Text('On Time',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceHigh,
            border: Border.all(
                color: AppColors.secondary.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8)
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Text(widget.staff.initials,
                    style: AppText.labelLg.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(
                        color: const Color(0xFF00120A), width: 2),
                  ),
                  child: const Icon(Icons.check,
                      size: 8, color: AppColors.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClockOutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF09241A), Color(0xFF052016)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top meta row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.contactless,
                      size: 18, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text('CLOCK OUT TERMINAL',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary),
                    ),
                    const SizedBox(width: 4),
                    Text('On Time',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                  ],
                ),
              ),
            ],
          ),
          Divider(
              height: 20,
              color: AppColors.outlineVariant.withOpacity(0.2)),
          // Shift timing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Scheduled Shift',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.8)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary),
                    ),
                    const SizedBox(width: 4),
                    Text('07h 48m Elapsed',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('08:00 AM — 05:00 PM',
              style: AppText.headlineMd.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text('Front Desk • Main Resort Pavilion',
                  style: AppText.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      color: AppColors.surfaceHighest.withOpacity(0.6),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.86,
                      child: Container(
                        height: 8,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFEE9800),
                              AppColors.secondary,
                              AppColors.primaryFixed,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Started 8:00 AM',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant)),
                  Text('86% completed',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                  Text('Ends 5:00 PM',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // RFID pulse badge + status
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _bounceAnim,
                  builder: (_, child) => Transform.scale(
                    scale: _bounceAnim.value,
                    child: child,
                  ),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.surfaceVariant,
                      border: Border.all(
                          color: AppColors.outlineVariant
                              .withOpacity(0.4)),
                    ),
                    child: const Icon(Icons.contactless,
                        size: 24, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_statusHeading,
                          style: AppText.bodyMd.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface)),
                      const SizedBox(height: 3),
                      Text(_statusDesc,
                          style: AppText.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // RFID tap button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, Color(0xFFE5A64D)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _simulateTap,
                icon: const Icon(Icons.nfc, size: 22),
                label: Text(_clockedOut
                    ? 'Simulate Clock In'
                    : 'Simulate RFID Tap'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: const Color(0xFF2A1700),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: AppText.labelLg.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2A1700)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
          // Feedback message
          AnimatedOpacity(
            opacity: _showFeedback ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(_feedbackMsg,
                    style: AppText.labelSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.history,
                    size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Text('SEPTEMBER 2026 HISTORY',
                    style: AppText.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.outlineVariant.withOpacity(0.3)),
              ),
              child: Text('21 shifts recorded',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF09241A), Color(0xFF052016)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.outlineVariant.withOpacity(0.3)),
          ),
          child: Column(
            children: List.generate(_history.length, (i) {
              final h = _history[i];
              final isLast = i == _history.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surfaceVariant
                                    .withOpacity(0.8),
                                border: Border.all(
                                    color: AppColors.outlineVariant
                                        .withOpacity(0.3)),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: h.onTime
                                    ? AppColors.primary
                                    : AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(h.date,
                                    style: AppText.bodyMd.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onSurface)),
                                const SizedBox(height: 2),
                                Text(h.range,
                                    style: AppText.bodySm.copyWith(
                                        color: AppColors
                                            .onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text(h.hours,
                                style: AppText.bodyMd.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: h.onTime
                                    ? AppColors.primary
                                        .withOpacity(0.15)
                                    : AppColors.secondary
                                        .withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(6),
                                border: Border.all(
                                  color: h.onTime
                                      ? AppColors.primary
                                          .withOpacity(0.3)
                                      : AppColors.secondary
                                          .withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                h.onTime
                                    ? 'On Time'
                                    : 'Late (17m)',
                                style: AppText.labelSm.copyWith(
                                    color: h.onTime
                                        ? AppColors.primary
                                        : AppColors.secondary,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 0,
                      color: AppColors.outlineVariant
                          .withOpacity(0.2),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _AttendRow {
  final String date;
  final String range;
  final String hours;
  final bool onTime;
  const _AttendRow(this.date, this.range, this.hours, this.onTime);
}
