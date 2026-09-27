import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

/// Result wrapper for OTP operations
class OtpResult {
  final bool success;
  final String? errorMessage;
  final bool expired;
  final int? expiresIn; // seconds until expiry

  const OtpResult._({
    required this.success,
    this.errorMessage,
    this.expired = false,
    this.expiresIn,
  });

  factory OtpResult.ok({int? expiresIn}) =>
      OtpResult._(success: true, expiresIn: expiresIn);

  factory OtpResult.fail(String message, {bool expired = false}) =>
      OtpResult._(success: false, errorMessage: message, expired: expired);
}

/// Service for sending and verifying OTP codes via Supabase Edge Functions
class OtpService {
  OtpService._();
  static final OtpService instance = OtpService._();

  // ── Send OTP ─────────────────────────────────────────────────────────────

  /// Generates a 6-digit code, saves it to the database, and emails it to the user.
  /// Returns success=true if the email was sent, or an error message otherwise.
  Future<OtpResult> sendOtp(String email) async {
    try {
      final response = await SupabaseClientService.client.functions.invoke(
        'send-otp',
        body: {'email': email.trim()},
      );

      if (response.status == 200) {
        final data = response.data as Map<String, dynamic>;
        return OtpResult.ok(expiresIn: data['expiresIn'] as int?);
      } else {
        final error = response.data is Map
            ? (response.data as Map<String, dynamic>)['error'] as String?
            : null;
        return OtpResult.fail(
          error ?? 'Failed to send verification code. Please try again.',
        );
      }
    } on FunctionException catch (e) {
      return OtpResult.fail(_mapFunctionError(e.details));
    } catch (e) {
      return OtpResult.fail(
        'Network error. Please check your connection and try again.',
      );
    }
  }

  // ── Verify OTP ───────────────────────────────────────────────────────────

  /// Checks if the submitted code is valid and not expired.
  /// Returns success=true if valid, or an error message with expired flag.
  Future<OtpResult> verifyOtp(String email, String code) async {
    try {
      final response = await SupabaseClientService.client.functions.invoke(
        'verify-otp',
        body: {
          'email': email.trim(),
          'code': code.trim(),
        },
      );

      if (response.status == 200) {
        return OtpResult.ok();
      } else {
        final data = response.data is Map
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
        final error = data['error'] as String?;
        final expired = data['expired'] as bool? ?? false;

        return OtpResult.fail(
          error ??
              'Invalid verification code. Please check and try again.',
          expired: expired,
        );
      }
    } on FunctionException catch (e) {
      final details = e.details;
      final expired = details is Map && (details['expired'] as bool? ?? false);
      return OtpResult.fail(_mapFunctionError(details), expired: expired);
    } catch (e) {
      return OtpResult.fail(
        'Network error. Please check your connection and try again.',
      );
    }
  }

  // ── Resend OTP ───────────────────────────────────────────────────────────

  /// Convenience method — same as sendOtp but semantically clear for UI.
  Future<OtpResult> resendOtp(String email) => sendOtp(email);

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _mapFunctionError(dynamic details) {
    if (details is Map) {
      final error = details['error'];
      if (error is String) return error;
    }
    if (details is String) return details;
    return 'An unexpected error occurred. Please try again.';
  }
}
