import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../widgets/concierge_fab.dart';
import '../utils/booking_nav.dart';
import '../services/booking_service.dart';
import '../services/auth_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _activeFilter = 'all';
  List<BookingRecord> _bookings = [];
  bool _loadingBookings = true;

  static const _filters = [
    _FilterChip('all', Icons.tune, 'All'),
    _FilterChip('pending', Icons.hourglass_top, 'Pending'),
    _FilterChip('confirmed', Icons.check_circle, 'Confirmed'),
    _FilterChip('completed', Icons.task_alt, 'Completed'),
    _FilterChip('cancelled', Icons.cancel, 'Cancelled'),
  ];

  static const _retreats = [
    _RetreatCard(
      tag: 'VIP Lagoon',
      title: 'Private Pool & Pavilion',
      subtitle: 'Day Tour & Overnight',
      price: 'From ₱8,500',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDm1k11IbQ5cIeNtX3cZ0f3JeI3z6atDyRzJAgjG7p8kxxG4U8PG5DcX9OTNPlx1U8c7BdAaFaUARP_hN_8h_NoRmjvlFcBECYcRgvn6CdMyxyWoYxoDtlz7U1ZiqLCSjR_y75n56xJS_-6LHySNnjgzquGVsxBNi98TPPIRBmKT7Hs-NQj-Tk8qbxfSP5AkvELrVu3UjGODc_XPbmo8nEnaIaghFgQmlRGQcdMzS65Sw4qeeiJPvtEcw',
    ),
    _RetreatCard(
      tag: 'Event Hall',
      title: 'Grand Thysia Pavilion',
      subtitle: 'Up to 150 Guests',
      price: 'From ₱25,000',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAPplEzm9ChWoVMb_VD2q4RdcTsXHyCD00AMxcPfvPXY0ZU_13r7QlwczZkCGfk-qbaFgn6ggBh6un9yGwDXRbHb1TzqzQnLI0h7HwWAzwZKYgJhBKXnV6s4K2O4Uj_ZhMLbKmLFJXIwGBSOqfPjnh0_N93oAD9d-ZBEynwplhAd6HVTN7--y21-L2M9PpA-rw_uC6GF4_EXBHVogjLQ8ofjYrI0eA-zMTdAGoLQKytX-5D131fpZoiWA',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    if (!AuthService.instance.isLoggedIn) {
      setState(() => _loadingBookings = false);
      return;
    }
    final records = await BookingService.instance.fetchMyBookings();
    if (!mounted) return;
    setState(() {
      _bookings = records;
      _loadingBookings = false;
    });
  }

  List<BookingRecord> get _filteredBookings {
    if (_activeFilter == 'all') return _bookings;
    return _bookings
        .where((b) => b.status == _activeFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: ConciergeFab(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User & clock sub-bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary)),
                      const SizedBox(width: 6),
                      Text('Juan Dela Cruz',
                          style: AppText.labelMd
                              .copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 4),
                      Text('• Portal',
                          style: AppText.labelSm
                              .copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 12, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text('09:18 PM • Sep 23',
                          style: AppText.labelSm
                              .copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('STA. CRUZ, LAGUNA',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.8)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary)),
                    const SizedBox(width: 4),
                    Text('Private Resort & Event Place',
                        style: AppText.labelSm
                            .copyWith(color: AppColors.secondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stat cards
            Row(
              children: [
                _statCard('${_bookings.length}', 'Total\nStays',
                    AppColors.primary, Icons.calendar_month),
                const SizedBox(width: 8),
                _statCard(
                    '${_bookings.where((b) => b.status == 'confirmed').length}',
                    'Confirmed',
                    AppColors.tertiary,
                    Icons.verified),
                const SizedBox(width: 8),
                _statCard(
                    '${_bookings.where((b) => b.status == 'completed').length}',
                    'Completed',
                    AppColors.secondary,
                    Icons.done_all),
              ],
            ),
            const SizedBox(height: 16),

            // Filter label row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('FILTER BOOKINGS',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('${_filteredBookings.length} active records',
                      style: AppText.labelSm
                          .copyWith(color: AppColors.secondary)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Filter chips (horizontal scroll)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (_, i) {
                  final f = _filters[i];
                  final isActive = _activeFilter == f.key;
                  return Padding(
                    padding: EdgeInsets.only(
                        right: i < _filters.length - 1 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _activeFilter = f.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                      color:
                                          AppColors.primary.withOpacity(0.2),
                                      blurRadius: 4)
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(f.icon,
                                size: 14,
                                color: isActive
                                    ? AppColors.onPrimary
                                    : _filterIconColor(f.key)),
                            const SizedBox(width: 6),
                            Text(f.label,
                                style: AppText.labelMd.copyWith(
                                    color: isActive
                                        ? AppColors.onPrimary
                                        : AppColors.onSurface,
                                    fontWeight: isActive
                                        ? FontWeight.w700
                                        : FontWeight.w400)),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.onPrimary.withOpacity(0.2)
                                    : AppColors.surfaceHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('0',
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.onSurfaceVariant,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Bookings list or empty/loading state
            _loadingBookings
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary, strokeWidth: 2.5),
                    ),
                  )
                : _filteredBookings.isNotEmpty
                    ? _buildBookingsList()
                    : _buildEmptyState(),

            const SizedBox(height: 16),

            // Featured retreats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Featured Retreats',
                    style: AppText.titleMd
                        .copyWith(fontWeight: FontWeight.w600)),
                Text('A&D EXCLUSIVES',
                    style: AppText.labelSm.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1)),
              ],
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: _retreats.length,
              itemBuilder: (_, i) {
                final r = _retreats[i];
                return GestureDetector(
                  onTap: () => navigateToBooking(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      color: AppColors.surfaceLow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: r.imageUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      Container(color: AppColors.surfaceHigh),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceLowest
                                          .withOpacity(0.8),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(r.tag,
                                        style: AppText.labelSm.copyWith(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.title,
                                    style: AppText.labelLg.copyWith(
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(r.subtitle,
                                    style: AppText.labelSm.copyWith(
                                        color: AppColors.onSurfaceVariant)),
                                const SizedBox(height: 4),
                                Text(r.price,
                                    style: AppText.labelMd.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Make new booking
            GestureDetector(
              onTap: () => navigateToBooking(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.add,
                          size: 20, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Text('Make a New Booking',
                        style: AppText.titleMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Concierge banner
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.support_agent,
                          size: 18, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text('Need reservation assistance?',
                          style: AppText.labelMd),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero),
                    child: Row(
                      children: [
                        Text('Chat Staff',
                            style: AppText.labelMd.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                        const Icon(Icons.chevron_right,
                            size: 14, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    String fmt(DateTime d) => '${months[d.month]} ${d.day}, ${d.year}';

    Color statusColor(String s) => switch (s) {
          'confirmed' => AppColors.primary,
          'completed' => AppColors.tertiary,
          'cancelled' => AppColors.error,
          _ => AppColors.secondary, // pending
        };

    return Column(
      children: _filteredBookings.map((b) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.outlineVariant.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: ref + status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#THY-${b.id.substring(0, 8).toUpperCase()}',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor(b.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: statusColor(b.status).withOpacity(0.4)),
                    ),
                    child: Text(
                      b.status.toUpperCase(),
                      style: AppText.labelSm.copyWith(
                          color: statusColor(b.status),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(b.facility,
                  style: AppText.labelLg
                      .copyWith(fontWeight: FontWeight.w700)),
              Text(b.package,
                  style: AppText.bodySm
                      .copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 12, color: AppColors.tertiary),
                  const SizedBox(width: 4),
                  Text('${fmt(b.checkIn)} – ${fmt(b.checkOut)}',
                      style: AppText.bodySm
                          .copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(width: 12),
                  const Icon(Icons.people,
                      size: 12, color: AppColors.tertiary),
                  const SizedBox(width: 4),
                  Text('${b.guests} guests',
                      style: AppText.bodySm
                          .copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.credit_card,
                          size: 12, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(b.paymentMethod,
                          style: AppText.bodySm
                              .copyWith(color: AppColors.secondary)),
                    ],
                  ),
                  Text(
                    '₱${b.totalAmount.toStringAsFixed(0)}',
                    style: AppText.labelLg.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surfaceHigh.withOpacity(0.9),
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calendar_today,
                      size: 36, color: AppColors.onSurfaceVariant),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 12, color: AppColors.onSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('No bookings yet',
              style: AppText.headlineSm
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Book your A&D Thysia Resort experience today! Escape to pure tropical serenity in Laguna.',
            style: AppText.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 220,
            child: ElevatedButton.icon(
              onPressed: () => navigateToBooking(context),
              icon: const Icon(Icons.event_seat, size: 20),
              label: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                shadowColor: AppColors.primary.withOpacity(0.2),
                elevation: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.surfaceVariant,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 8),
            Text(value,
                style: AppText.headlineMd.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 1)),
            const SizedBox(height: 2),
            Text(label,
                style: AppText.labelSm
                    .copyWith(color: AppColors.onSurfaceVariant),
                maxLines: 2),
          ],
        ),
      ),
    );
  }

  Color _filterIconColor(String key) {
    switch (key) {
      case 'awaiting-dp':
      case 'awaiting-pay':
        return AppColors.secondary;
      case 'confirmed':
        return AppColors.tertiary;
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.onSurfaceVariant;
    }
  }
}

class _FilterChip {
  final String key;
  final IconData icon;
  final String label;

  const _FilterChip(this.key, this.icon, this.label);
}

class _RetreatCard {
  final String tag;
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;

  const _RetreatCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
  });
}
