import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'staff_rfid_screen.dart';
import '../role_selector_screen.dart';

class StaffPayrollScreen extends StatefulWidget {
  final StaffMember staff;
  const StaffPayrollScreen({super.key, required this.staff});

  @override
  State<StaffPayrollScreen> createState() => _StaffPayrollScreenState();
}

class _StaffPayrollScreenState extends State<StaffPayrollScreen> {
  static const _payslips = [
    _Payslip('01 Aug 2026 – 15 Aug 2026', '₱19,090.00', 'THY-PR-202608A'),
    _Payslip('16 Jul 2026 – 31 Jul 2026', '₱18,860.00', 'THY-PR-202607B'),
    _Payslip('01 Jul 2026 – 15 Jul 2026', '₱17,940.00', 'THY-PR-202607A'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00120A),
      child: SafeArea(
        child: Column(
          children: [
            _statusBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildNetPayCard(),
                    const SizedBox(height: 12),
                    _buildMetricRow(),
                    const SizedBox(height: 12),
                    _buildPunctualityBanner(),
                    const SizedBox(height: 16),
                    _buildPayslipsSection(),
                    const SizedBox(height: 14),
                    _buildSupportCard(),
                    const SizedBox(height: 14),
                    _buildLogout(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('08:44',
              style: AppText.bodyMd.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  fontSize: 14)),
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Row(
            children: [
              Icon(Icons.signal_cellular_alt,
                  size: 15, color: AppColors.onSurface),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 15, color: AppColors.onSurface),
              SizedBox(width: 4),
              Icon(Icons.battery_full,
                  size: 17, color: AppColors.onSurface),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.spa,
                      size: 14, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text('WEDNESDAY, 23 SEPTEMBER 2026',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.secondary,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceHigh,
                border: Border.all(
                    color: AppColors.primaryContainer
                        .withOpacity(0.5)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(widget.staff.initials,
                        style: AppText.labelLg.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Earnings Summary',
            style: AppText.displayMobile.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 32)),
        const SizedBox(height: 6),
        Row(
          children: [
            Text('Current period: 01–15 Sep 2026',
                style: AppText.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                  '${widget.staff.rfidCode} • ${widget.staff.name}',
                  style: AppText.labelSm
                      .copyWith(color: AppColors.tertiary)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetPayCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ESTIMATED NET PAY',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Bi-Monthly',
                    style: AppText.labelSm.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('₱18,420.00',
              style: AppText.displayMobile.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  fontSize: 32)),
          Divider(
            height: 24,
            color: AppColors.surfaceVariant.withOpacity(0.3),
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified,
                      size: 17, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text('Calculated for 9 approved shifts',
                      style: AppText.bodySm
                          .copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
              GestureDetector(
                onTap: () => _showPayslipModal(
                    context, '01 Sep – 15 Sep 2026', '₱18,420.00',
                    'THY-PR-202609A'),
                child: Row(
                  children: [
                    Text('Details',
                        style: AppText.labelMd
                            .copyWith(color: AppColors.tertiary)),
                    const Icon(Icons.chevron_right,
                        size: 16, color: AppColors.tertiary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _metricCell('72h', 'Regular', null)),
            VerticalDivider(
              color: AppColors.surfaceVariant.withOpacity(0.4),
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('4h',
                      style: AppText.headlineSm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary)),
                  const Icon(Icons.bolt,
                      size: 14, color: AppColors.secondary),
                ],
              ),
            ),
            VerticalDivider(
              color: AppColors.surfaceVariant.withOpacity(0.4),
              thickness: 1,
              width: 1,
            ),
            Expanded(child: _metricCell('₱230', 'Rate/h', null)),
          ],
        ),
      ),
    );
  }

  Widget _metricCell(String value, String label, Color? color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value,
            style: AppText.headlineSm.copyWith(
                fontWeight: FontWeight.w700,
                color: color ?? AppColors.onSurface)),
        const SizedBox(height: 4),
        Text(label,
            style: AppText.labelSm
                .copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildPunctualityBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.verified_user,
                size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('100% Punctuality Score',
                    style: AppText.labelMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface)),
                Text('Zero late clock-ins this cycle',
                    style: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.stars, size: 20, color: AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildPayslipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Recent Payslips',
                    style: AppText.titleMd
                        .copyWith(color: AppColors.onSurface)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('3 archived',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant)),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text('Download All',
                      style: AppText.labelMd.copyWith(
                          color: AppColors.secondary)),
                  const Icon(Icons.file_download,
                      size: 16, color: AppColors.secondary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: _payslips
              .map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildPayslipItem(p),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPayslipItem(_Payslip p) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long,
                size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.period,
                    style: AppText.labelLg.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface),
                    overflow: TextOverflow.ellipsis),
                Text('System Generated • PDF',
                    style: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () =>
                _showPayslipModal(context, p.period, p.gross, p.refId),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('View',
                  style: AppText.labelMd.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.surfaceHigh),
            child: const Icon(Icons.help_center,
                size: 20, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payroll discrepancy?',
                    style: AppText.labelMd
                        .copyWith(color: AppColors.onSurface)),
                Text(
                    'HR Concierge desk is open 24/7 on extension 804',
                    style: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Contact',
                style: AppText.labelSm
                    .copyWith(color: AppColors.tertiary)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => const RoleSelectorScreen()),
            (_) => false,
          );
        },
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Log Out / Tap Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red[300],
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
          backgroundColor: Colors.red.withOpacity(0.06),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          textStyle: AppText.labelLg.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showPayslipModal(BuildContext context, String period,
      String gross, String refId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => _PayslipModal(
          period: period, gross: gross, refId: refId),
    );
  }
}

// ─── Payslip bottom sheet ─────────────────────────────────────────────────────
class _PayslipModal extends StatelessWidget {
  final String period;
  final String gross;
  final String refId;
  const _PayslipModal(
      {required this.period, required this.gross, required this.refId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PAYSLIP DETAILS',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.secondary,
                          letterSpacing: 1.2)),
                  Text(period,
                      style: AppText.headlineSm
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text('Reference ID: $refId',
                      style: AppText.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant)),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceVariant,
                  ),
                  child: const Icon(Icons.close,
                      size: 18, color: AppColors.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _row('Gross Earnings', gross, AppColors.onSurface),
                const SizedBox(height: 8),
                _row('Statutory Deductions (SSS/PhilHealth/HDMF)',
                    '-₱670.00', AppColors.error),
                const SizedBox(height: 8),
                _row('Service Charge Share (Luxury Tier)',
                    '+₱3,450.00', AppColors.tertiary),
                Divider(
                    height: 20,
                    color: AppColors.surfaceVariant,
                    thickness: 1),
                _row('Net Disbursed', '₱18,420.00',
                    AppColors.secondary,
                    bold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                        color: AppColors.outlineVariant),
                    foregroundColor: AppColors.onSurface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Close', style: AppText.labelLg),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Get PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: AppText.labelLg,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color valueColor,
      {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label,
              style: AppText.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant)),
        ),
        Text(value,
            style: AppText.bodyMd.copyWith(
                color: valueColor,
                fontWeight:
                    bold ? FontWeight.w700 : FontWeight.w600)),
      ],
    );
  }
}

class _Payslip {
  final String period;
  final String gross;
  final String refId;
  const _Payslip(this.period, this.gross, this.refId);
}
