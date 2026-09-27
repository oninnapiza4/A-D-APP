import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/guest_signin_screen.dart';
import '../screens/booking_screen.dart';

/// Call this from ANY "Book Now" button.
/// – If logged in  → go straight to BookingScreen.
/// – If not logged in → show sign-in; after success redirect to BookingScreen.
void navigateToBooking(BuildContext context) {
  if (AuthService.instance.isLoggedIn) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BookingScreen()),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GuestSignInScreen(
          redirectToBooking: true,
        ),
      ),
    );
  }
}
