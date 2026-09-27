import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin accessor so the rest of the app never imports supabase_flutter directly.
///
/// Usage:
///   final client = SupabaseClientService.client;
///   final user   = SupabaseClientService.currentUser;
class SupabaseClientService {
  SupabaseClientService._();

  /// The global Supabase client initialised in main.dart.
  static SupabaseClient get client => Supabase.instance.client;

  /// Convenience — currently signed-in user, or null.
  static User? get currentUser => client.auth.currentUser;

  /// True when someone is signed in.
  static bool get isLoggedIn => currentUser != null;
}
