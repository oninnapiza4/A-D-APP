import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'theme/app_theme.dart';
import 'screens/role_selector_screen.dart';
import 'screens/main_guest_shell.dart';
import 'services/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Load .env ────────────────────────────────────────────────────────────
  await dotenv.load(fileName: '.env');

  // ── Initialise Supabase ───────────────────────────────────────────────────
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // ── Status bar styling ───────────────────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ADThysiaApp());
}

class ADThysiaApp extends StatelessWidget {
  const ADThysiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "A&D Thysia Resort",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // If the user already has a valid session (app restart), land them on
      // the shell; otherwise show the role selector.
      home: SupabaseClientService.isLoggedIn
          ? const MainGuestShell()
          : const RoleSelectorScreen(),
    );
  }
}
