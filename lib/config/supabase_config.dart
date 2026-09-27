import 'package:flutter_dotenv/flutter_dotenv.dart';

/// All Supabase credentials are loaded from the `.env` asset file.
/// Only the public anon key is needed on the client; the service-role key
/// must NEVER be embedded in a Flutter app.
class SupabaseConfig {
  SupabaseConfig._();

  static String get url =>
      dotenv.env['SUPABASE_URL'] ??
      (throw StateError('SUPABASE_URL not set in .env'));

  static String get anonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ??
      (throw StateError('SUPABASE_ANON_KEY not set in .env'));
}
