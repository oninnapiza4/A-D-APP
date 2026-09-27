/// Shared widgets and constants used by both GuestSignInScreen
/// and GuestSignUpScreen.
library auth_widgets;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const String kLogoUrl =
    'https://lh3.googleusercontent.com/aida/AEtjO1VN0v8VTYBldPyDxM0th7kaWBgoyAVap4HRVYRjmBEcczxry-G6lFhkvkHosQGOQX8azBdZe1OqqBJjid73kP9iSb4kMWJz8Vpw2VuGkVMRR9eDguTkLl-8knUbGI1pdz1pc9lt6n4Ot4HKEMR3HYsAbjvdo0uTajK6g2njB6NSD6hY-YA8ejMaac_SoJIqnmhOhHtv_zdN8jwFGvky1YOzKsjNbxpTSxD02yrcatSmN8Ywz7AKmDkY2jb-';

Widget buildLogoFallback() => Container(
      color: const Color(0xFF092E20),
      child: const Center(
        child: Text(
          'A&D',
          style: TextStyle(
            color: Color(0xFFFFB95F),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );

// ─── Gold squircle logo badge (used on both screens) ─────────────────────────

class AuthLogoBadge extends StatelessWidget {
  /// If [goldBorder] is true → sign-in style (gold gradient frame).
  /// If false → sign-up style (glowing halo frame).
  final bool goldBorder;
  const AuthLogoBadge({super.key, this.goldBorder = true});

  @override
  Widget build(BuildContext context) {
    if (goldBorder) {
      // Sign-in style: gold gradient border
      return Container(
        width: 96,
        height: 96,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFDDB8),
              Color(0xFFFFB95F),
              Color(0xFFB37822),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: kLogoUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (_, __, ___) => buildLogoFallback(),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        Color(0x18FFFFFF),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sign-up style: glowing halo
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.secondary.withOpacity(0.30),
                AppColors.primary.withOpacity(0.30),
                AppColors.tertiary.withOpacity(0.20),
              ],
            ),
          ),
        ),
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: AppColors.surfaceLowest,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.25),
                blurRadius: 20,
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.20),
                blurRadius: 20,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: kLogoUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => buildLogoFallback(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Field label ──────────────────────────────────────────────────────────────

class AuthFieldLabel extends StatelessWidget {
  final String label;
  final String? trailing;
  const AuthFieldLabel({super.key, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppText.labelMd.copyWith(
            color: const Color(0xFFD1FAE5),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            fontSize: 13,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppText.labelSm.copyWith(
              color: AppColors.primary.withOpacity(0.8),
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}

// ─── Text field ───────────────────────────────────────────────────────────────

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final Widget? prefix;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.suffix,
    this.prefix,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      style: AppText.bodyMd.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.bodyMd.copyWith(
          color: const Color(0xFFD1FAE5).withOpacity(0.4),
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xFF072218),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColors.primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColors.primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.error, width: 1.5),
        ),
        errorStyle: AppText.labelSm.copyWith(color: AppColors.error),
        suffixIcon: suffix,
        prefixIcon: prefix,
      ),
    );
  }
}

// ─── Small checkbox ───────────────────────────────────────────────────────────

class AuthCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const AuthCheckbox(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: value
              ? const Color(0xFF10B981)
              : const Color(0xFF072218),
          border: Border.all(
            color: value
                ? const Color(0xFF10B981)
                : AppColors.primary.withOpacity(0.4),
          ),
        ),
        child: value
            ? const Icon(Icons.check, size: 11, color: Colors.white)
            : null,
      ),
    );
  }
}

// ─── Gradient primary button ──────────────────────────────────────────────────

class AuthGradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final LinearGradient gradient;
  final Color? borderColor;

  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.gradient,
    this.icon,
    this.borderColor,
  });

  @override
  State<AuthGradientButton> createState() => _AuthGradientButtonState();
}

class _AuthGradientButtonState extends State<AuthGradientButton> {
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(12),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: AppText.bodyMd.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                Icon(widget.icon,
                    size: 16, color: const Color(0xFFFFDDB8)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Or divider ───────────────────────────────────────────────────────────────

class AuthOrDivider extends StatelessWidget {
  final String label;
  const AuthOrDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              height: 1,
              color: const Color(0xFF0F3825).withOpacity(0.6)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: AppText.labelSm.copyWith(
              color: const Color(0xFF34D399).withOpacity(0.6),
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
              height: 1,
              color: const Color(0xFF0F3825).withOpacity(0.6)),
        ),
      ],
    );
  }
}

// ─── Google sign-in button ────────────────────────────────────────────────────

class AuthGoogleButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  const AuthGoogleButton(
      {super.key, required this.onTap, this.label = 'Google'});

  @override
  State<AuthGoogleButton> createState() => _AuthGoogleButtonState();
}

class _AuthGoogleButtonState extends State<AuthGoogleButton> {
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
            color: const Color(0xFF072218).withOpacity(0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.primary.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CustomPaint(painter: _GoogleIconPainter()),
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: AppText.bodyMd.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);
    final rect = Rect.fromCircle(center: center, radius: r);

    void arc(double start, double sweep, Color color) {
      canvas.drawArc(rect, start, sweep, true, Paint()..color = color);
    }

    arc(-1.57, 3.14, const Color(0xFF4285F4));
    arc(1.57, 1.57, const Color(0xFF34A853));
    arc(3.14, 0.78, const Color(0xFFFBBC05));
    arc(-1.57, -1.57, const Color(0xFFEA4335));
    // White hole
    canvas.drawCircle(
        center, r * 0.45, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Background painters ──────────────────────────────────────────────────────

class LeafWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.shader = RadialGradient(
      center: const Alignment(0.8, -0.7),
      radius: 0.5,
      colors: [
        const Color(0xFF4EDEA3).withOpacity(0.08),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.shader = RadialGradient(
      center: const Alignment(-0.8, -0.1),
      radius: 0.45,
      colors: [
        const Color(0xFFFFB95F).withOpacity(0.05),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.shader = RadialGradient(
      center: const Alignment(1.0, 0.5),
      radius: 0.55,
      colors: [
        const Color(0xFF10B981).withOpacity(0.07),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FoliagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = const Color(0xFF4EDEA3);
    final p2 = Paint()..color = const Color(0xFFFFB95F);
    final p3 = Paint()..color = const Color(0xFF10B981);

    final path1 = Path()
      ..moveTo(size.width * 0.90, size.height * 0.042)
      ..cubicTo(
          size.width * 0.60, size.height * 0.167,
          size.width * 0.40, size.height * 0.333,
          size.width * 0.50, size.height * 0.458)
      ..cubicTo(
          size.width * 0.60, size.height * 0.583,
          size.width * 0.90, size.height * 0.50,
          size.width * 0.95, size.height * 0.375)
      ..cubicTo(
          size.width * 1.0, size.height * 0.25,
          size.width * 0.98, size.height * 0.104,
          size.width * 0.90, size.height * 0.042)
      ..close();
    canvas.drawPath(path1, p1);

    final path2 = Path()
      ..moveTo(size.width * 1.0, size.height * 0.354)
      ..cubicTo(
          size.width * 0.70, size.height * 0.458,
          size.width * 0.50, size.height * 0.625,
          size.width * 0.65, size.height * 0.771)
      ..cubicTo(
          size.width * 0.75, size.height * 0.854,
          size.width * 1.05, size.height * 0.792,
          size.width * 1.0, size.height * 0.667)
      ..cubicTo(
          size.width * 0.95, size.height * 0.542,
          size.width * 1.02, size.height * 0.417,
          size.width * 1.0, size.height * 0.354)
      ..close();
    canvas.drawPath(path2, p2);

    final path3 = Path()
      ..moveTo(size.width * 0.95, size.height * 0.708)
      ..cubicTo(
          size.width * 0.75, size.height * 0.792,
          size.width * 0.60, size.height * 0.938,
          size.width * 0.75, size.height * 1.042)
      ..cubicTo(
          size.width * 0.85, size.height * 1.104,
          size.width * 1.10, size.height * 1.021,
          size.width * 1.05, size.height * 0.917)
      ..cubicTo(
          size.width * 1.0, size.height * 0.813,
          size.width * 1.0, size.height * 0.75,
          size.width * 0.95, size.height * 0.708)
      ..close();
    canvas.drawPath(path3, p3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
