import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../services/otp_service.dart';
import '../services/auth_service.dart';
import 'main_guest_shell.dart';
import 'booking_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String password;
  final String fullName;
  final String mobile;
  final bool redirectToBooking;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.password,
    required this.fullName,
    required this.mobile,
    this.redirectToBooking = false,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _verifying = false;
  bool _resending = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;
  String? _errorMessage;

  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeCtrl);

    // Auto-focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _cooldownTimer?.cancel();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ── Get entered code ─────────────────────────────────────────────────────

  String get _code => _controllers.map((c) => c.text).join();

  bool get _codeComplete => _code.length == 6;

  // ── Clear all boxes ──────────────────────────────────────────────────────

  void _clearCode() {
    for (var c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  // ── Verify OTP ───────────────────────────────────────────────────────────

  Future<void> _verify() async {
    if (!_codeComplete) return;

    setState(() {
      _verifying = true;
      _errorMessage = null;
    });

    final result =
        await OtpService.instance.verifyOtp(widget.email, _code);

    if (!mounted) return;

    if (result.success) {
      // OTP verified — now create the Supabase auth account
      await _createAuthAccount();
    } else {
      setState(() {
        _verifying = false;
        _errorMessage = result.errorMessage;
      });
      _shakeCtrl.forward(from: 0);
      _clearCode();
    }
  }

  // ── Create Supabase auth account after OTP verified ─────────────────────

  Future<void> _createAuthAccount() async {
    final authResult = await AuthService.instance.signUp(
      email: widget.email,
      password: widget.password,
      fullName: widget.fullName,
      mobile: widget.mobile,
    );

    if (!mounted) return;

    if (authResult.success) {
      // Auto sign-in after successful registration
      final signInResult = await AuthService.instance.signIn(
        email: widget.email,
        password: widget.password,
      );

      if (!mounted) return;

      if (signInResult.success) {
        _showSuccess();
        await Future.delayed(const Duration(milliseconds: 1200));
        if (!mounted) return;
        _navigateToApp();
      } else {
        setState(() {
          _verifying = false;
          _errorMessage =
              'Account created but sign-in failed. Please sign in manually.';
        });
      }
    } else {
      setState(() {
        _verifying = false;
        _errorMessage = authResult.errorMessage ??
            'Failed to create account. Please try again.';
      });
    }
  }

  // ── Navigate after success ───────────────────────────────────────────────

  void _navigateToApp() {
    if (widget.redirectToBooking) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainGuestShell()),
        (route) => false,
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BookingScreen()),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainGuestShell()),
        (route) => false,
      );
    }
  }

  // ── Show success animation ───────────────────────────────────────────────

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary),
            const SizedBox(width: 12),
            Text('Email verified successfully!', style: AppText.bodySm),
          ],
        ),
        backgroundColor: AppColors.primaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Resend OTP ───────────────────────────────────────────────────────────

  Future<void> _resendOtp() async {
    if (_resendCooldown > 0 || _resending) return;

    setState(() {
      _resending = true;
      _errorMessage = null;
    });

    final result = await OtpService.instance.resendOtp(widget.email);

    if (!mounted) return;

    setState(() => _resending = false);

    if (result.success) {
      _startCooldown(60);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification code resent to ${widget.email}',
            style: AppText.bodySm,
          ),
          backgroundColor: AppColors.primaryContainer,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _clearCode();
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  // ── Cooldown timer ───────────────────────────────────────────────────────

  void _startCooldown(int seconds) {
    setState(() => _resendCooldown = seconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000D08),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.2,
                  colors: [
                    AppColors.primary.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // ── Header ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),

                // ── Main content ───────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.12),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 2),
                          ),
                          child: const Icon(Icons.mail_outline,
                              size: 36, color: AppColors.primary),
                        ),

                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Verify Your Email',
                          style: AppText.headlineLg.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'We sent a 6-digit verification code to',
                          style: AppText.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.email,
                          style: AppText.labelMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 40),

                        // ── OTP Input boxes ────────────────────────────────
                        AnimatedBuilder(
                          animation: _shakeAnim,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_shakeAnim.value, 0),
                              child: child,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (i) {
                              return Container(
                                margin: EdgeInsets.only(
                                    right: i < 5 ? 12 : 0),
                                child: _OtpBox(
                                  controller: _controllers[i],
                                  focusNode: _focusNodes[i],
                                  onChanged: (val) {
                                    if (val.isNotEmpty && i < 5) {
                                      _focusNodes[i + 1].requestFocus();
                                    }
                                    if (val.isEmpty && i > 0) {
                                      _focusNodes[i - 1].requestFocus();
                                    }
                                    // Auto-submit when 6th digit entered
                                    if (i == 5 &&
                                        val.isNotEmpty &&
                                        _codeComplete) {
                                      _verify();
                                    }
                                    setState(() {});
                                  },
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Error message ──────────────────────────────────
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.errorContainer.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.error.withOpacity(0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 18, color: AppColors.error),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: AppText.bodySm
                                        .copyWith(color: AppColors.error),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 32),

                        // ── Verify button ──────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed:
                                _codeComplete && !_verifying ? _verify : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor:
                                  AppColors.surfaceContainer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: _verifying
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.onPrimary,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Verify Email',
                                    style: AppText.labelLg.copyWith(
                                      color: _codeComplete
                                          ? AppColors.onPrimary
                                          : AppColors.onSurfaceVariant,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Resend link ────────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: AppText.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant),
                            ),
                            if (_resendCooldown > 0)
                              Text(
                                'Resend in ${_resendCooldown}s',
                                style: AppText.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant),
                              )
                            else
                              GestureDetector(
                                onTap: _resending ? null : _resendOtp,
                                child: Text(
                                  _resending ? 'Sending...' : 'Resend',
                                  style: AppText.bodySm.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OTP Input Box Widget
// ═══════════════════════════════════════════════════════════════════════════

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focusNode.hasFocus
              ? AppColors.primary
              : AppColors.outlineVariant.withOpacity(0.3),
          width: focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppText.headlineMd.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
