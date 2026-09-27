 import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';
import '../services/otp_service.dart';
import 'guest_signin_screen.dart';
import 'email_verification_screen.dart';
import 'booking_screen.dart';

class GuestSignUpScreen extends StatefulWidget {
  /// When true, after successful registration navigate to BookingScreen.
  final bool redirectToBooking;

  const GuestSignUpScreen({
    super.key,
    this.redirectToBooking = false,
  });

  @override
  State<GuestSignUpScreen> createState() => _GuestSignUpScreenState();
}

class _GuestSignUpScreenState extends State<GuestSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _promoOptIn = true;
  bool _termsAccepted = false;
  bool _loading = false;

  // Touch flags
  bool _nameTouched = false;
  bool _emailTouched = false;
  bool _mobileTouched = false;
  bool _passwordTouched = false;
  bool _confirmTouched = false;

  // Password strength 0–3
  int _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(_onPasswordChanged);
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Password strength ────────────────────────────────────────────────────────

  void _onPasswordChanged() {
    final p = _passwordCtrl.text;
    int s = 0;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9!@#\$%^&*()\-_=+]'))) s++;
    setState(() => _passwordStrength = s);
  }

  // ── Validators ───────────────────────────────────────────────────────────────

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    if (v.trim().length < 2) return 'Enter your full name';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateMobile(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Enter a valid mobile number';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  void _onAuthSuccess() {
    // This is now called AFTER OTP verification in EmailVerificationScreen
    // Left here for compatibility but not used in the new flow
  }

  void _createAccount() async {
    setState(() {
      _nameTouched = true;
      _emailTouched = true;
      _mobileTouched = true;
      _passwordTouched = true;
      _confirmTouched = true;
    });

    if (!_formKey.currentState!.validate()) return;

    if (!_termsAccepted) {
      _showError('Please accept the Terms of Service to continue.');
      return;
    }

    setState(() => _loading = true);

    // Send OTP to email
    final result = await OtpService.instance.sendOtp(_emailCtrl.text.trim());

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      // Navigate to OTP verification screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EmailVerificationScreen(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
            fullName: _nameCtrl.text.trim(),
            mobile: _mobileCtrl.text.trim(),
            redirectToBooking: widget.redirectToBooking,
          ),
        ),
      );
    } else {
      _showError(result.errorMessage ?? 'Failed to send verification code.');
    }
  }

  void _googleSignUp() async {
    _showError('Google sign-up coming soon. Please use email & password.');
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: AppText.bodySm),
        backgroundColor: AppColors.errorContainer,
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
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Ambient glow orbs
          Positioned(
            top: -96,
            right: -80,
            child: Container(
              width: 288,
              height: 288,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            top: 384,
            left: -112,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.secondary.withOpacity(0.10),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTopNav(),
                  _buildLogoHeader(),
                  const SizedBox(height: 12),
                  _buildRegistrationCard(),
                  const SizedBox(height: 16),
                  _buildPerksStrip(),
                  const SizedBox(height: 20),
                  _buildFooter(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top nav ──────────────────────────────────────────────────────────────────

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back,
                      size: 18, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'Sign In',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logo header ──────────────────────────────────────────────────────────────

  Widget _buildLogoHeader() {
    return Column(
      children: [
        const AuthLogoBadge(goldBorder: false),
        const SizedBox(height: 12),
        Text(
          'A&D Thysia Resort',
          style: AppText.headlineMd.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '• Events Place •',
          style: AppText.labelSm.copyWith(
              color: AppColors.primary, letterSpacing: 2),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.spa,
                  size: 14, color: AppColors.secondary),
              const SizedBox(width: 5),
              Text(
                'NEW GUEST REGISTRATION',
                style: AppText.labelSm.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Registration card ────────────────────────────────────────────────────────

  Widget _buildRegistrationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.80),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighest.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.eco,
                    size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                'Create Your Account',
                style: AppText.headlineSm
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Join the Thysia Sanctuary for seamless villa reservations, exclusive resort rates, and personalized bespoke stays.',
            style: AppText.bodySm.copyWith(
              color: AppColors.secondary.withOpacity(0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // ── Form ──────────────────────────────────────────────────────────
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                _formLabel(Icons.person_outline, 'Full Name'),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: _nameCtrl,
                  hint: 'Juan Dela Cruz',
                  keyboardType: TextInputType.name,
                  validator: _validateName,
                  onChanged: (_) {
                    if (!_nameTouched) setState(() => _nameTouched = true);
                  },
                ),
                const SizedBox(height: 14),

                // Email
                _formLabel(Icons.mail_outline, 'Email Address'),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: _emailCtrl,
                  hint: 'juan@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onChanged: (_) {
                    if (!_emailTouched) setState(() => _emailTouched = true);
                  },
                ),
                const SizedBox(height: 14),

                // Mobile
                _formLabel(Icons.call_outlined, 'Mobile Number'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Country code badge
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🇵🇭',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text('+63',
                              style: AppText.labelMd.copyWith(
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(width: 2),
                          const Icon(Icons.expand_more,
                              size: 14, color: AppColors.outline),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AuthTextField(
                        controller: _mobileCtrl,
                        hint: '917 123 4567',
                        keyboardType: TextInputType.phone,
                        validator: _validateMobile,
                        onChanged: (_) {
                          if (!_mobileTouched) {
                            setState(() => _mobileTouched = true);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Password
                _formLabel(Icons.lock_outline, 'Password'),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: _passwordCtrl,
                  hint: 'Create strong password',
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
                      color: AppColors.outline,
                    ),
                    onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 8),
                // Strength bar
                _PasswordStrengthBar(strength: _passwordStrength),
                const SizedBox(height: 6),
                // Strength labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StrengthLabel(
                        label: '8+ chars',
                        met: _passwordStrength >= 1,
                        activeColor: AppColors.primary),
                    _StrengthLabel(
                        label: 'Uppercase',
                        met: _passwordStrength >= 2,
                        activeColor: AppColors.secondary),
                    _StrengthLabel(
                        label: 'Number/Symbol',
                        met: _passwordStrength >= 3,
                        activeColor: AppColors.outlineVariant),
                  ],
                ),
                const SizedBox(height: 14),

                // Confirm Password
                _formLabel(
                    Icons.verified_user_outlined, 'Confirm Password'),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: _confirmCtrl,
                  hint: 'Re-enter password',
                  obscureText: _obscureConfirm,
                  validator: _validateConfirm,
                  onChanged: (_) {
                    if (!_confirmTouched) {
                      setState(() => _confirmTouched = true);
                    }
                  },
                  suffix: _confirmCtrl.text.isNotEmpty
                      ? (_confirmCtrl.text == _passwordCtrl.text
                          ? const Icon(Icons.check_circle,
                              size: 20, color: AppColors.primary)
                          : IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.outline,
                              ),
                              onPressed: () => setState(() =>
                                  _obscureConfirm = !_obscureConfirm),
                            ))
                      : null,
                ),
                const SizedBox(height: 18),

                // Promo opt-in
                _CheckboxRow(
                  value: _promoOptIn,
                  onChanged: (v) =>
                      setState(() => _promoOptIn = v ?? true),
                  child: Text(
                    'Receive exclusive resort offers, seasonal discounts & event invitations via SMS/Email',
                    style: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant, height: 1.4),
                  ),
                ),
                const SizedBox(height: 12),

                // Terms
                _CheckboxRow(
                  value: _termsAccepted,
                  onChanged: (v) =>
                      setState(() => _termsAccepted = v ?? false),
                  child: RichText(
                    text: TextSpan(
                      style: AppText.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant, height: 1.4),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        _linkSpan('Terms of Service'),
                        const TextSpan(text: ', '),
                        _linkSpan('Guest Booking Policies'),
                        const TextSpan(text: ', and '),
                        _linkSpan('Privacy Policy'),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Create Account CTA
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary, strokeWidth: 2.5),
                      )
                    : AuthGradientButton(
                        label: 'Create Account',
                        icon: Icons.arrow_forward,
                        onTap: _createAccount,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryContainer,
                            AppColors.tertiaryContainer,
                            AppColors.primaryContainer,
                          ],
                        ),
                      ),
                const SizedBox(height: 14),

                // Divider
                AuthOrDivider(label: 'or sign up with'),
                const SizedBox(height: 12),

                // Google
                AuthGoogleButton(
                    onTap: _googleSignUp,
                    label: 'Continue with Google'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Perks strip ──────────────────────────────────────────────────────────────

  Widget _buildPerksStrip() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _PerkItem(Icons.loyalty, 'Best Rates',
              'Exclusive guest perks', AppColors.secondary),
          _PerkItem(Icons.pool, 'Priority Booking',
              'Villa & pavilion holds', AppColors.primary),
          _PerkItem(Icons.room_service_outlined, 'Custom Stays',
              'Direct concierge chat', AppColors.tertiary),
        ],
      ),
    );
  }

  // ── Footer ───────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: AppText.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant),
            children: [
              const TextSpan(text: 'Already have an account?  '),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (_) => GuestSignInScreen(
                              redirectToBooking: widget.redirectToBooking,
                            )),
                  ),
                  child: Text(
                    'Sign In',
                    style: AppText.bodyMd.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          AppColors.secondary.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
            width: 48,
            height: 2,
            color: AppColors.surfaceHighest),
        const SizedBox(height: 8),
        Text(
          "A&D Thysia Resort & Event's Place\nSta. Cruz, Laguna, Philippines",
          style: AppText.labelSm.copyWith(
              color: AppColors.outline.withOpacity(0.8), height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Private helpers ───────────────────────────────────────────────────────────

  Widget _formLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(label,
            style: AppText.labelMd
                .copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  TextSpan _linkSpan(String text) => TextSpan(
        text: text,
        style: AppText.bodySm.copyWith(
          color: AppColors.secondary,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.secondary.withOpacity(0.5),
        ),
      );
}

// ─── Password Strength Bar ────────────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  final int strength;
  const _PasswordStrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        Color color;
        if (i < strength) {
          color = i == 0
              ? AppColors.primary
              : i == 1
                  ? AppColors.secondary
                  : AppColors.tertiary;
        } else {
          color = AppColors.surfaceHighest;
        }
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 6,
            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Strength label ───────────────────────────────────────────────────────────

class _StrengthLabel extends StatelessWidget {
  final String label;
  final bool met;
  final Color activeColor;
  const _StrengthLabel(
      {required this.label,
      required this.met,
      required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 12,
          color: met ? activeColor : AppColors.outlineVariant,
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppText.labelSm.copyWith(
            color: met ? activeColor : AppColors.outlineVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Checkbox row ─────────────────────────────────────────────────────────────

class _CheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget child;
  const _CheckboxRow({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.translucent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: value ? AppColors.primary : AppColors.surfaceLowest,
              border: Border.all(
                color: value
                    ? AppColors.primary
                    : AppColors.outlineVariant.withOpacity(0.6),
              ),
            ),
            child: value
                ? const Icon(Icons.check,
                    size: 14, color: AppColors.onPrimary)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─── Perk item ────────────────────────────────────────────────────────────────

class _PerkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  const _PerkItem(this.icon, this.label, this.sub, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(label,
              style: AppText.labelSm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface),
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(sub,
              style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                  fontFamily: 'Plus Jakarta Sans'),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
