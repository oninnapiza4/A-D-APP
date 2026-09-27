import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'staff_rfid_screen.dart';
import 'staff_today_screen.dart';
import 'staff_attendance_screen.dart';
import 'staff_handover_screen.dart';
import 'staff_payroll_screen.dart';

class StaffShell extends StatefulWidget {
  final StaffMember staff;
  const StaffShell({super.key, required this.staff});

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  int _index = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      StaffTodayScreen(staff: widget.staff),
      StaffAttendanceScreen(staff: widget.staff),
      StaffHandoverScreen(staff: widget.staff),
      StaffPayrollScreen(staff: widget.staff),
    ];
  }

  static const _tabs = [
    _Tab(Icons.today,         Icons.today,          'Today'),
    _Tab(Icons.schedule,      Icons.schedule,       'Attendance'),
    _Tab(Icons.swap_horiz,    Icons.swap_horiz,     'Handover'),
    _Tab(Icons.receipt_long,  Icons.receipt_long,   'Payroll'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00120A),
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00170E).withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: Color(0xFF1B3824), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (i) {
              final active = _index == i;
              return GestureDetector(
                onTap: () => setState(() => _index = i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? _tabs[i].activeIcon : _tabs[i].icon,
                        size: 22,
                        color: active
                            ? const Color(0xFFFBBF24)
                            : const Color(0xFF34D399).withOpacity(0.6),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _tabs[i].label,
                        style: AppText.labelSm.copyWith(
                          color: active
                              ? const Color(0xFFFBBF24)
                              : const Color(0xFF34D399).withOpacity(0.6),
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? const Color(0xFFFBBF24)
                              : Colors.transparent,
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFFBBF24)
                                        .withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _Tab(this.icon, this.activeIcon, this.label);
}
