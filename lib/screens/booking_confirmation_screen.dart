import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/booking_service.dart';
import 'main_guest_shell.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String facility;
  final String package;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double total;
  final String paymentMethod;

  const BookingConfirmationScreen({
    super.key,
    required this.facility,
    required this.package,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.total,
    required this.paymentMethod,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  // Supabase record created after confirmation
  BookingRecord? _savedRecord;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();

    // Persist the booking to Supabase in the background
    _saveBooking();
  }

  Future<void> _saveBooking() async {
    final result = await BookingService.instance.createBooking(
      facility: widget.facility,
      package: widget.package,
      checkIn: widget.checkIn,
      checkOut: widget.checkOut,
      guests: widget.guests,
      totalAmount: widget.total,
      paymentMethod: widget.paymentMethod,
    );
    if (!mounted) return;
    setState(() {
      if (result.success) {
        _savedRecord = result.record;
      } else {
        _saveError = result.errorMessage;
      }
    });
  }

  String _fmt(DateTime d) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                // Success icon
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryContainer,
                          AppColors.primary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_circle_outline,
                        size: 52, color: AppColors.onPrimary),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Booking Confirmed!',
                    style: AppText.headlineLg.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                  'Your reservation at A&D Thysia Resort\nhas been submitted.',
                  style: AppText.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Confirmation card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Booking ref
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Booking Reference',
                                style: AppText.labelSm.copyWith(
                                    color: AppColors.onSurfaceVariant)),
                            Text(
                              _savedRecord != null
                                  ? '#THY-${_savedRecord!.id.substring(0, 8).toUpperCase()}'
                                  : '#THY-${DateTime.now().millisecondsSinceEpoch % 100000}',
                              style: AppText.labelLg.copyWith(
                                  color: AppColors.primary,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _detailRow(Icons.villa, 'Facility',
                          widget.facility),
                      _divider(),
                      _detailRow(Icons.hotel_class, 'Package',
                          widget.package),
                      _divider(),
                      _detailRow(Icons.login, 'Check-in',
                          _fmt(widget.checkIn)),
                      _divider(),
                      _detailRow(Icons.logout, 'Check-out',
                          _fmt(widget.checkOut)),
                      _divider(),
                      _detailRow(Icons.people, 'Guests',
                          '${widget.guests} guests'),
                      _divider(),
                      _detailRow(Icons.credit_card, 'Payment',
                          widget.paymentMethod),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payments,
                                  size: 16,
                                  color: AppColors.secondary),
                              const SizedBox(width: 8),
                              Text('Total Amount',
                                  style: AppText.bodyMd.copyWith(
                                      color:
                                          AppColors.onSurfaceVariant)),
                            ],
                          ),
                          Text(
                              '₱${widget.total.toStringAsFixed(0)}',
                              style: AppText.headlineSm.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Supabase save status ───────────────────────────────────
                if (_saveError != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.error.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_off,
                            size: 16, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Booking saved locally, but cloud sync failed: $_saveError',
                            style: AppText.bodySm
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_savedRecord != null && _saveError == null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_done,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Booking saved to your account ✓',
                          style: AppText.bodySm
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),

                // Deposit notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.secondary.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.account_balance_wallet,
                          size: 20, color: AppColors.secondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Send ₱1,000 Downpayment',
                                style: AppText.labelLg.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(
                              'GCash / Maya / QRPh — to confirm your slot. Show receipt to front desk upon arrival. Non-refundable.',
                              style: AppText.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Go to My Bookings
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryContainer,
                          AppColors.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) =>
                                const MainGuestShell(initialIndex: 1),
                          ),
                          (_) => false,
                        );
                      },
                      icon: const Text('View My Bookings'),
                      label: const Icon(Icons.arrow_forward, size: 18),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: AppColors.onPrimary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textStyle: AppText.labelLg
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const MainGuestShell()),
                      (_) => false,
                    );
                  },
                  child: Text('Back to Home',
                      style: AppText.labelLg.copyWith(
                          color: AppColors.onSurfaceVariant)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(label,
                  style: AppText.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant)),
            ],
          ),
          Text(value,
              style: AppText.labelMd.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface)),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
      height: 0,
      thickness: 1,
      color: AppColors.outlineVariant.withOpacity(0.2));
}
