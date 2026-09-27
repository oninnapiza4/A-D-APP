import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

/// Result wrapper so callers can show typed error messages without
/// catching raw exceptions throughout the UI.
class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  const AuthResult._({
    required this.success,
    this.errorMessage,
    this.user,
  });

  factory AuthResult.ok(User user) =>
      AuthResult._(success: true, user: user);

  factory AuthResult.fail(String message) =>
      AuthResult._(success: false, errorMessage: message);
}

/// Central auth service backed by Supabase Auth.
///
/// The old in-memory flag `_isLoggedIn` is replaced with the real
/// Supabase session so state survives hot-restarts and app restarts.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // ── Convenience getters ──────────────────────────────────────────────────

  bool get isLoggedIn => SupabaseClientService.isLoggedIn;
  User? get currentUser => SupabaseClientService.currentUser;

  String get currentUserName {
    final meta = currentUser?.userMetadata;
    if (meta != null && meta['full_name'] != null) {
      return meta['full_name'] as String;
    }
    return currentUser?.email?.split('@').first ?? 'Guest';
  }

  String get currentUserEmail => currentUser?.email ?? '';

  // ── Sign up ──────────────────────────────────────────────────────────────

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullName,
    required String mobile,
  }) async {
    try {
      final res = await SupabaseClientService.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'full_name': fullName.trim(),
          'mobile': mobile.trim(),
        },
        // Disable Supabase's default email confirmation flow
        // We handle OTP verification manually via our custom Edge Functions
        emailRedirectTo: null,
      );

      if (res.user == null) {
        return AuthResult.fail(
          'Registration failed. Please try again.',
        );
      }

      // Upsert a profile row in the public.profiles table (if it exists).
      // This is a best-effort call — the table may not exist yet and that
      // is fine; real schema setup belongs in Supabase migrations.
      await _upsertProfile(
        userId: res.user!.id,
        fullName: fullName.trim(),
        mobile: mobile.trim(),
        email: email.trim(),
      );

      return AuthResult.ok(res.user!);
    } on AuthException catch (e) {
      return AuthResult.fail(_mapAuthError(e.message));
    } catch (e) {
      return AuthResult.fail('An unexpected error occurred. Please try again.');
    }
  }

  // ── Sign in ──────────────────────────────────────────────────────────────

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res =
          await SupabaseClientService.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (res.user == null) {
        return AuthResult.fail('Sign-in failed. Please try again.');
      }

      return AuthResult.ok(res.user!);
    } on AuthException catch (e) {
      return AuthResult.fail(_mapAuthError(e.message));
    } catch (e) {
      return AuthResult.fail('An unexpected error occurred. Please try again.');
    }
  }

  // ── Sign out ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      await SupabaseClientService.client.auth.signOut();
    } catch (_) {
      // Swallow — even if the remote call fails we still clear local state.
    }
  }

  // ── Password reset ───────────────────────────────────────────────────────

  Future<AuthResult> sendPasswordReset(String email) async {
    try {
      await SupabaseClientService.client.auth
          .resetPasswordForEmail(email.trim());
      return AuthResult.ok(currentUser ?? _dummyUser());
    } on AuthException catch (e) {
      return AuthResult.fail(_mapAuthError(e.message));
    } catch (e) {
      return AuthResult.fail('Could not send reset email. Please try again.');
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _upsertProfile({
    required String userId,
    required String fullName,
    required String mobile,
    required String email,
  }) async {
    try {
      await SupabaseClientService.client.from('profiles').upsert({
        'id': userId,
        'full_name': fullName,
        'mobile': mobile,
        'email': email,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Non-fatal — the profiles table may not exist yet.
    }
  }

  /// Maps Supabase raw error messages to user-friendly strings.
  String _mapAuthError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('invalid login')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please verify your email address first.';
    }
    if (lower.contains('user already registered') ||
        lower.contains('already been registered')) {
      return 'An account with this email already exists. Try signing in.';
    }
    if (lower.contains('password should be')) {
      return 'Password must be at least 6 characters.';
    }
    if (lower.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    return raw;
  }

  // Dummy user for methods that need to return a user but it's optional.
  User _dummyUser() => currentUser!;
}
