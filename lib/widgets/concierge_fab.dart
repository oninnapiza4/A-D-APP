import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConciergeFab extends StatefulWidget {
  const ConciergeFab({super.key});

  @override
  State<ConciergeFab> createState() => _ConciergeFabState();
}

class _ConciergeFabState extends State<ConciergeFab>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Dialog bubble
        ScaleTransition(
          scale: _scaleAnim,
          alignment: Alignment.bottomRight,
          child: _open ? _buildDialog() : const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        // FAB button
        GestureDetector(
          onTap: _toggle,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLowest,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.45),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _BotPainter(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialog() {
    return Container(
      width: 272,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('Thysia Concierge',
                      style: AppText.labelMd
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              GestureDetector(
                onTap: _toggle,
                child: const Icon(Icons.close,
                    size: 18, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Mabuhay! Looking to reserve private waterfalls access or inquire about weekend cabin rates?',
            style: AppText.bodySm
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          _dialogBtn(
            'Check Dates Availability',
            AppColors.primary,
            Icons.arrow_forward,
          ),
          const SizedBox(height: 6),
          _dialogBtn(
            'Call Guest Relations',
            AppColors.secondary,
            Icons.call,
          ),
        ],
      ),
    );
  }

  Widget _dialogBtn(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppText.labelSm.copyWith(color: color)),
          Icon(icon, size: 14, color: color),
        ],
      ),
    );
  }
}

// ─── Custom SVG-equivalent bot face painter ───────────────────────────────────
class _BotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer ring gradient
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF10B981), Color(0xFF4EDEA3), Color(0xFFFFDDB8)],
      ).createShader(Rect.fromCircle(
          center: Offset(cx, cy), radius: cx * 0.89));

    canvas.drawCircle(Offset(cx, cy), cx * 0.89, ringPaint);

    // Inner ring
    final innerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF4EDEA3).withOpacity(0.95);
    canvas.drawCircle(Offset(cx, cy), cx * 0.55, innerRing);

    // Face plate rect
    final facePaint = Paint()..color = const Color(0xFF001008);
    final faceRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(cx, cy + 1),
          width: size.width * 0.76,
          height: size.height * 0.64),
      const Radius.circular(16),
    );
    canvas.drawRRect(faceRect, facePaint);

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF4EDEA3);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - cx * 0.28, cy - 1),
          width: 7, height: 9),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + cx * 0.28, cy - 1),
          width: 7, height: 9),
      eyePaint,
    );

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF4EDEA3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(cx - cx * 0.24, cy + cy * 0.22)
      ..quadraticBezierTo(cx, cy + cy * 0.38, cx + cx * 0.24, cy + cy * 0.22);
    canvas.drawPath(smilePath, smilePaint);

    // Online pip
    final pipPaint = Paint()..color = const Color(0xFF4EDEA3);
    canvas.drawCircle(Offset(cx + cx * 0.58, cy - cy * 0.58), 7, pipPaint);
    final pipBorder = Paint()
      ..color = const Color(0xFF00170E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(cx + cx * 0.58, cy - cy * 0.58), 7, pipBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
