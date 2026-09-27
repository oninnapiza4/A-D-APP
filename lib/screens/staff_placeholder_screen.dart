// Redirects to the real staff RFID access screen.
export 'staff/staff_rfid_screen.dart' show StaffRfidScreen;

import 'package:flutter/material.dart';
import 'staff/staff_rfid_screen.dart';

/// Thin wrapper kept for backward compatibility with role_selector_screen.dart.
/// It immediately renders the full StaffRfidScreen.
class StaffPlaceholderScreen extends StatelessWidget {
  const StaffPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => const StaffRfidScreen();
}
