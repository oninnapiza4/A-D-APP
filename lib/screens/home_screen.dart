import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../widgets/resort_app_bar.dart';
import '../widgets/concierge_fab.dart';
import '../utils/booking_nav.dart';
import 'guest_signin_screen.dart';

class HomeScreen extends StatefulWidget {
  /// When [standalone] is true (default), HomeScreen renders its own
  /// Scaffold with AppBar and bottom nav — used when accessed directly.
  /// When false, only the scrollable content is rendered — used inside
  /// MainGuestShell which provides the Scaffold, AppBar and bottom nav.
  final bool standalone;
  const HomeScreen({super.key, this.standalone = true});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  static const String _heroUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC4Zm2vp5vn0zdmKp9A8JaQuckcmoHcxDOQxCOkHf6EQErGnSRpxQ6eVYvtkxsMqwIBa1nv2YF--QLK8UMcci94f26t5_MdlQpY5_m-0erpz2fOPDT_CvE60s6W1xqwBHHs8ChnFpM5HsSAUJfo1DudP-Y8vsnEwlVuWpW3_pgAGt4ox0TvKNLUY612VghYUoD5_D5H83O2W1Ok6e28p2YCf-AgnWpfJbCC9PsueCJGurVp7_lg63WPfr8etugB67y1c8M';

  static const String _cabanaUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBsxPvxpysDYS8z5cwv3_N5C_d0Iq48Bqlg7Pu0kVqnJG5EbiZmpf84W7SResAPE6ZDDg1jX-g-TQ-_azHVXxzIRW9TzK2rQTYERHh8ztTFimpTE5MYvbbm3rEh4E7UrdLMOn-L0NEbLkV_e97dYXpNC9dLGUBTRpNdtkHuuaRzoYCPqf1aqj5dt_UZXl_BifVkAsBevFkoxSqoOyTtXsRUa-nV7r81VBGmNDx-NTUnQhCiwWxO3POG0Q';

  static const String _poolUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD3Dh7QpZp6qRYKLrbVGsAfhNSiEOsJHSXRDXhwoGbuxxfh5DWqguItAZpT_7nmo_p_sdz3YGYLPXR4e3KS6RUjSt7iGdkvlhYbx9zuSKR_rswjNlki4-pKucjfgo84eWZQxRGdPgr8akpCsKSDr9hsnuJigo3lyJosyF4t4w0_oOJfNABkBhQtuSGqcq7LZTAyTfgGH6Ik-76fSyqcBKTFTIGR2v16BeVNzVELjMGOZVM6su8t62BBdw';

  static const String _campfireUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBCUk8cs-qIxNyMJAI2g2EIceglyY2bZnxD8piBGNlRiAzY56u33jfRSjfNcVhVCahjusWMafmuhjX2MGCcu0t_nu_gzt7WNiHCLGuwjVPwvK19ez9pIFqsEKVBffFBrigS1lgIk08TjnNdDmZNVin4Q64sN0-79U5_44ImGjSzAAE7wi4i0h9hOy1svQUpT4RrFarcyKIThYtsAy56OWUmrGJsZbu0mR4pXdELtK1OwDDrkxmzw3VbdA';

  void _goToBooking() {
    navigateToBooking(context);
  }

  @override
  Widget build(BuildContext context) {
    // ── Embedded mode (inside MainGuestShell) ────────────────────────────────
    // Return only the scrollable tab content — the shell owns Scaffold/AppBar/nav
    if (!widget.standalone) {
      return _buildHomeTab();
    }

    // ── Standalone mode (direct navigation, e.g. from RoleSelector) ─────────
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ResortAppBar(
        title: 'A&D Thysia',
        subtitle: 'A&D Thysia',
        showBookNow: true,
        onBookNow: _goToBooking,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _navIndex,
        children: [
          _buildHomeTab(),
          _buildAboutTab(),
          _buildFacilitiesTab(),
          _buildGalleryTab(),
        ],
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 72),
        child: ConciergeFab(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero section
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: _heroUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                          color: AppColors.surfaceContainer),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surfaceContainer,
                        child: const Icon(Icons.image,
                            color: AppColors.outline),
                      ),
                    ),
                    // Top-to-bottom gradient
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xB200120A),
                            Colors.transparent,
                            Color(0xCC00120A),
                          ],
                          stops: [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                    // Badges top row
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _glassBadge(
                            icon: Icons.location_on,
                            label: 'Sta. Cruz, Laguna',
                            iconColor: AppColors.secondary,
                          ),
                          _glassBadge(
                            icon: Icons.star,
                            label: '4.9  (120+)',
                            iconColor: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                    // Bottom overlay card
                    Positioned(
                      bottom: 16,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer
                              .withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 40,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.secondary
                                    .withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('A&D Thysia',
                                style: AppText.headlineLg
                                    .copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(
                              "RESORT & EVENT'S PLACE",
                              style: AppText.labelLg.copyWith(
                                color: AppColors.secondary,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Where Nature Meets Serenity',
                              style: AppText.titleMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Escape to a hidden paradise of cascading waterfalls, crystal-clear natural spring pools, and lush tropical sanctuary.',
                              style: AppText.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _goToBooking,
                                icon: const Text('Explore Suites & Rates'),
                                label: const Icon(
                                    Icons.arrow_forward, size: 18),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primaryContainer,
                                  foregroundColor: AppColors.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  textStyle: AppText.labelLg.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Golden divider
          _buildGoldenDivider(),

          // Our Story
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.spa,
                        size: 20, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    Text(
                      'OUR HERITAGE & VISION',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.secondary, letterSpacing: 1.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Discover Our Story',
                    style: AppText.headlineMd
                        .copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(
                  'Nestled in the heart of lush tropical greenery in Sta. Cruz, Laguna, A&D Thysia Resort is an exclusive eco-sanctuary designed for family getaways, intimate nature retreats, and milestone celebrations.',
                  style: AppText.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _featurePill(
                        icon: Icons.cabin,
                        label: 'Private Cabins',
                        color: AppColors.primary),
                    _featurePill(
                        icon: Icons.water_drop,
                        label: 'Crystal Springs',
                        color: AppColors.secondary),
                    _featurePill(
                        icon: Icons.celebration,
                        label: 'Grand Events',
                        color: AppColors.tertiary),
                  ],
                ),
              ],
            ),
          ),

          // Facilities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURATED EXPERIENCES',
                  style: AppText.labelSm
                      .copyWith(color: AppColors.primary, letterSpacing: 1.5),
                ),
                const SizedBox(height: 4),
                Text('Resort Facilities & Amenities',
                    style: AppText.headlineMd
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  'Exclusive resort highlights designed for unhurried relaxation',
                  style: AppText.bodySm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                // Pavilion full-width
                _facilityRow(
                  icon: Icons.festival,
                  iconColor: AppColors.secondary,
                  title: 'Event Pavilion',
                  subtitle:
                      'Grand covered pavilion for weddings, milestone parties, and corporate gatherings.',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _facilityCard(
                        icon: Icons.pool,
                        iconColor: AppColors.secondary,
                        title: 'Swimming Pool',
                        subtitle:
                            'Adult infinity & kiddie crystal spring pools',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _facilityCard(
                        icon: Icons.hotel,
                        iconColor: AppColors.secondary,
                        title: 'Rooms & Suites',
                        subtitle:
                            'Cozy overnight stays, deluxe rooms & rustic cabins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Gallery teaser
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VISUAL TOUR',
                            style: AppText.labelSm.copyWith(
                                color: AppColors.primary,
                                letterSpacing: 1.5)),
                        Text('Glimpse of Thysia',
                            style: AppText.titleMd
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          setState(() => _navIndex = 3),
                      label: const Text('View All'),
                      icon: const Icon(Icons.chevron_right, size: 16),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 176,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: _cabanaUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                    color: AppColors.surfaceHigh),
                              ),
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color(0xCC00120A),
                                    ],
                                  ),
                                ),
                              ),
                              const Positioned(
                                bottom: 8,
                                left: 10,
                                child: Text('Private Cabanas',
                                    style: TextStyle(
                                        color: AppColors.onSurface,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: _poolUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorWidget: (_, __, ___) => Container(
                                      color: AppColors.surfaceHigh),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: _campfireUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorWidget: (_, __, ___) => Container(
                                      color: AppColors.surfaceHigh),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Location card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        child: const Icon(Icons.pin_drop,
                            size: 22, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Brgy. Oogong, Sta. Cruz',
                              style: AppText.labelLg
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text('Laguna, Philippines',
                              style: AppText.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Day Tour: 8 AM – 5 PM | Overnight Available',
                        style: AppText.bodySm
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.spa, size: 64, color: AppColors.secondary),
          const SizedBox(height: 16),
          Text('About A&D Thysia',
              style: AppText.headlineMd
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Nestled in the heart of lush tropical greenery in Sta. Cruz, Laguna, A&D Thysia Resort is an exclusive eco-sanctuary designed for family getaways, intimate nature retreats, and milestone celebrations. We celebrate pure mountain springs and handcrafted architecture.',
            style: AppText.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant, height: 1.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _facilityDetailCard(
            icon: Icons.festival,
            title: 'Event Pavilion',
            desc:
                'Grand covered pavilion ideal for weddings, debuts, and corporate gatherings. Capacity: up to 150 guests.',
          ),
          _facilityDetailCard(
            icon: Icons.pool,
            title: 'Swimming Pools',
            desc:
                'Adults infinity & kids crystal spring pools. Open 8 AM – 11 PM for overnight guests.',
          ),
          _facilityDetailCard(
            icon: Icons.hotel,
            title: 'Rooms & Cabins',
            desc:
                'Private cabins with 2 beds, cooling fan. Deluxe rooms also available. 2–4 pax per unit.',
          ),
          _facilityDetailCard(
            icon: Icons.fireplace,
            title: 'Bonfire Pit',
            desc:
                'Dedicated bonfire pit & free tent pitching zone for guests.',
          ),
          _facilityDetailCard(
            icon: Icons.wifi,
            title: 'Free Wi-Fi',
            desc:
                'High-speed guest Wi-Fi available across all premises.',
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    final List<String> images = [
      _heroUrl,
      _cabanaUrl,
      _poolUrl,
      _campfireUrl,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDm1k11IbQ5cIeNtX3cZ0f3JeI3z6atDyRzJAgjG7p8kxxG4U8PG5DcX9OTNPlx1U8c7BdAaFaUARP_hN_8h_NoRmjvlFcBECYcRgvn6CdMyxyWoYxoDtlz7U1ZiqLCSjR_y75n56xJS_-6LHySNnjgzquGVsxBNi98TPPIRBmKT7Hs-NQj-Tk8qbxfSP5AkvELrVu3UjGODc_XPbmo8nEnaIaghFgQmlRGQcdMzS65Sw4qeeiJPvtEcw',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAPplEzm9ChWoVMb_VD2q4RdcTsXHyCD00AMxcPfvPXY0ZU_13r7QlwczZkCGfk-qbaFgn6ggBh6un9yGwDXRbHb1TzqzQnLI0h7HwWAzwZKYgJhBKXnV6s4K2O4Uj_ZhMLbKmLFJXIwGBSOqfPjnh0_N93oAD9d-ZBEynwplhAd6HVTN7--y21-L2M9PpA-rw_uC6GF4_EXBHVogjLQ8ofjYrI0eA-zMTdAGoLQKytX-5D131fpZoiWA',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (_, i) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: images[i],
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              Container(color: AppColors.surfaceContainer),
          errorWidget: (_, __, ___) =>
              Container(color: AppColors.surfaceHigh),
        ),
      ),
    );
  }

  Widget _facilityDetailCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: AppColors.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.labelLg
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(desc,
                    style: AppText.bodySm
                        .copyWith(color: AppColors.onSurfaceVariant,
                            height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldenDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.secondary],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.8),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassBadge(
      {required IconData icon,
      required String label,
      required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(label,
              style: AppText.labelSm
                  .copyWith(color: AppColors.onSurface)),
        ],
      ),
    );
  }

  Widget _featurePill(
      {required IconData icon,
      required String label,
      required Color color}) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: AppText.labelMd.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _facilityRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 30, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.labelLg
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _facilityCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 30, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: AppText.labelLg
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppText.bodySm
                .copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      _NavItem(icon: Icons.villa, label: 'Home'),
      _NavItem(icon: Icons.spa, label: 'About'),
      _NavItem(icon: Icons.pool, label: 'Facilities'),
      _NavItem(icon: Icons.photo_library, label: 'Gallery'),
    ];

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (i) => GestureDetector(
            onTap: () => setState(() => _navIndex = i),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].icon,
                    size: 22,
                    color: _navIndex == i
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].label,
                    style: AppText.labelSm.copyWith(
                      color: _navIndex == i
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight: _navIndex == i
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
