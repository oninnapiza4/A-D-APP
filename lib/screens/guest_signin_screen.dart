import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';
import '../services/auth_service.dart';
import 'guest_signup_screen.dart';
import 'main_guest_shell.dart';
import 'booking_screen.dart';

class GuestSignInScreen extends StatefulWidget {
  /// When true, after successful sign-in navigate to BookingScreen
  /// instead of the main shell.
  final bool redirectToBooking;

  const GuestSignInScreen({
    super.key,
    this.redirectToBooking = false,
  });

  @override
  State<GuestSignInScreen> createState() => _GuestSignInScreenState();
}

class _GuestSignInScreenState extends State<GuestSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _loading = false;

  bool _emailTouched = false;
  bool _passwordTouched = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Validators ───────────────────────────────────────────────────────────────

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  // ── After successful auth navigate ───────────────────────────────────────────

  void _onAuthSuccess() {
    if (!mounted) return;
    if (widget.redirectToBooking) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainGuestShell()),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BookingScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainGuestShell()),
      );
    }
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  void _signIn() async {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await AuthService.instance.signIn(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      _onAuthSuccess();
    } else {
      _showError(result.errorMessage ?? 'Sign-in failed.');
    }
  }

  void _googleSignIn() async {
    // Google OAuth requires a redirect URL configured in Supabase.
    // Show a placeholder snack until that is configured.
    _showError('Google sign-in coming soon. Please use email & password.');
  }

  void _browseAsGuest() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainGuestShell()),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: AppText.bodySm),
        backgroundColor: AppColors.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showError('Enter your email address first, then tap Forgot Password.');
      return;
    }
    setState(() => _loading = true);
    final result = await AuthService.instance.sendPasswordReset(email);
    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success
              ? 'Password reset email sent to $email.'
              : result.errorMessage ?? 'Could not send reset email.',
          style: AppText.bodySm,
        ),
        backgroundColor: result.success
            ? AppColors.primaryContainer
            : AppColors.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000D08),
      body: Stack(
        children: [
          // Leaf watermark radial glow background
          Positioned.fill(
            child: CustomPaint(painter: LeafWatermarkPainter()),
          ),
          // Foliage decoration — right side
          Positioned(
            right: -25,
            top: 190,
            width: 220,
            height: 480,
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(painter: FoliagePainter()),
            ),
          ),
          // Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeroHeader(),
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(24, 4, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBackButton(),
                        const SizedBox(height: 16),
                        _buildWelcomeCard(),
                        const SizedBox(height: 20),
                        _buildForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero header ──────────────────────────────────────────────────────────────

  Widget _buildHeroHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        children: [
          // Ambient glow + logo
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF10B981).withOpacity(0.15),
                    Colors.transparent,
                  ]),
                ),
              ),
              const AuthLogoBadge(goldBorder: true),
            ],
          ),
          const SizedBox(height: 14),
          // Gradient title
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Colors.white, Color(0xFFFFDDB8), Color(0xFFFFB95F)],
            ).createShader(b),
            child: Text(
              'A&D Thysia Resort',
              style: AppText.headlineMd.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Portal pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF062318).withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFB95F),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Guest Portal & Bookings',
                  style: AppText.bodySm.copyWith(
                    color: const Color(0xFFD1FAE5).withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Back button ──────────────────────────────────────────────────────────────

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF09241A),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Icon(Icons.arrow_back,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Text(
            'Back to Home',
            style: AppText.bodyMd.copyWith(
              color: const Color(0xFF34D399),
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Welcome card ─────────────────────────────────────────────────────────────

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF09241A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF10B981),
                      Color(0xFF044833),
                    ],
                  ),
                  border: Border.all(
                      color: const Color(0xFFFFB95F)
                          .withOpacity(0.3)),
                ),
                child: const Icon(Icons.eco,
                    size: 16, color: Color(0xFFFFDDB8)),
              ),
              const SizedBox(width: 10),
              Text(
                'Guest Welcome',
                style: AppText.headlineSm.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Welcome back! Sign in to manage your bookings and resort getaways.',
            style: AppText.bodySm.copyWith(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.w500,
              height: 1.5,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ── Sign-in form ─────────────────────────────────────────────────────────────

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email
          AuthFieldLabel(
              label: 'Email Address', trailing: 'Registered Guest'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: _emailCtrl,
            hint: 'your@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onChanged: (_) {
              if (!_emailTouched) setState(() => _emailTouched = true);
            },
          ),
          const SizedBox(height: 16),

          // Password
          const AuthFieldLabel(label: 'Password'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: _passwordCtrl,
            hint: 'Min 8 chars, uppercase, number',
            obscureText: _obscurePassword,
            validator: _validatePassword,
            onChanged: (_) {
              if (!_passwordTouched) {
                setState(() => _passwordTouched = true);
              }
            },
            suffix: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.primary.withOpacity(0.7),
              ),
              onPressed: () => setState(
                  () => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 12),

          // Remember me + Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AuthCheckbox(
                    value: _rememberMe,
                    onChanged: (v) =>
                        setState(() => _rememberMe = v ?? false),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remember this device',
                    style: AppText.bodySm.copyWith(
                      color: const Color(0xFFD1FAE5).withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _forgotPassword(),
                child: Text(
                  'Forgot Password?',
                  style: AppText.bodySm.copyWith(
                    color: AppColors.goldAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sign In CTA
          _loading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 2.5),
                )
              : AuthGradientButton(
                  label: 'Sign In',
                  icon: Icons.arrow_forward,
                  onTap: _signIn,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF10B981),
                      Color(0xFF059669),
                      Color(0xFF047857),
                    ],
                  ),
                  borderColor: const Color(0xFFFFB95F).withOpacity(0.4),
                ),
          const SizedBox(height: 20),

          // Or divider
          AuthOrDivider(label: 'or sign in with'),
          const SizedBox(height: 14),

          // Google
          AuthGoogleButton(onTap: _googleSignIn, label: 'Google'),
          const SizedBox(height: 10),

          // Browse as guest
          _BrowseGuestButton(onTap: _browseAsGuest),
          const SizedBox(height: 24),

          // Sign up link
          Center(
            child: RichText(
              text: TextSpan(
                style: AppText.bodySm.copyWith(
                  color: const Color(0xFFD1FAE5).withOpacity(0.8),
                  fontSize: 13,
                ),
                children: [
                  const TextSpan(text: 'Need an account?  '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => GuestSignUpScreen(
                                  redirectToBooking:
                                      widget.redirectToBooking,
                                )),
                      ),
                      child: Text(
                        'Sign Up',
                        style: AppText.bodyMd.copyWith(
                          color: AppColors.goldAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.goldAccent
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Browse as guest button ───────────────────────────────────────────────────

class _BrowseGuestButton extends StatefulWidget {
  final VoidCallback onTap;
  const _BrowseGuestButton({required this.onTap});

  @override
  State<_BrowseGuestButton> createState() => _BrowseGuestButtonState();
}

class _BrowseGuestButtonState extends State<_BrowseGuestButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.99 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFF0A291E).withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFFFFB95F).withOpacity(0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore_outlined,
                  size: 16, color: Color(0xFFFFB95F)),
              const SizedBox(width: 8),
              Text(
                'Browse as Guest / View Rates',
                style: AppText.bodyMd.copyWith(
                  color: const Color(0xFFFFDDB8),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
