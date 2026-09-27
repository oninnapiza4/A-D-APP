import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../widgets/concierge_fab.dart';
import 'booking_confirmation_screen.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

class _Facility {
  final String name;
  final String subtitle;
  final String capacity;
  final String imageUrl;
  final IconData icon;
  const _Facility({
    required this.name,
    required this.subtitle,
    required this.capacity,
    required this.imageUrl,
    required this.icon,
  });
}

class _Package {
  final String tag;
  final String label;
  final String schedule;
  final String desc;
  final double price;
  final IconData icon;
  final String imageUrl;
  final List<String> inclusions;
  const _Package({
    required this.tag,
    required this.label,
    required this.schedule,
    required this.desc,
    required this.price,
    required this.icon,
    required this.imageUrl,
    required this.inclusions,
  });
}

// ─── Static data ──────────────────────────────────────────────────────────────

const _facilities = [
  _Facility(
    name: 'Cabin A – Deluxe Suite',
    subtitle: 'Private cabin with garden view',
    capacity: '2–4 guests',
    icon: Icons.cabin,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCNPP3qKddOglXN2gL9tKOe0kaCeGJF2gN5mGMm7Q8pKCc_5y054nQErJ1Zq4RoboTH9O2f8xJgnNCgEOG-3BPO-JdxApGwDmXwbLhE9oldlDA3bhqesn4CtkC1uURe2DC0Fhtc5SsbQCwcoHZw0Gj0zU_d4Lviq-DhmZAyyGqn_ExZPe9h2vSrYDqeMXX5gN2uaFzcRb-s35iq_vJBEEslmR_pGdQ7_SlOnI-lB7Tmy4WDb_0Yy75u9Q',
  ),
  _Facility(
    name: 'Cabin B – Standard Room',
    subtitle: 'Cozy room near pool area',
    capacity: '2–3 guests',
    icon: Icons.hotel,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA2P5jJ3S9IQGQG3pRbDGvdR0-Dnwn2FxH-DIGkGoOnianaqHrt81oWzN88oC2_6hdzCuxYlr7DxAoRw1mxEjRFms8vQsK9xSyluaFem81kOPaG_KoZuw8sCLumvGIbNFkrYVOh3lnqF96n3fhlNGxr44_Lf3KhJD7V2spy6Kj4PoMJ6mSH1fd3yea0pxngAXTH3Yld8-OogiXXJFFjKi7A-MWJESL9fp8ya5cdv9xPD2aXT1yb2bvDBw',
  ),
  _Facility(
    name: 'Event Pavilion',
    subtitle: 'Grand open-air covered venue',
    capacity: 'Up to 150 guests',
    icon: Icons.festival,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAZcBV6tmVum7YUkDwzW3Rl3cod8tOmLTm8NtsqADCXigxcL1JEyDl09z3fhTHUmn-pJqFEX_a8djPBrZKeFpMq66CRz4aMTyZ7h3ln-107eCF3_fWXKq4xwjXZQ_UD2Sk-WtfEKK1Su1Rsur9G8NWNyXVEW2opPQDARRUTDs0c8nYGep4d5ugaVvzkZjnZpqdN-A',
  ),
  _Facility(
    name: 'VIP Pool & Lagoon',
    subtitle: 'Private infinity pool access',
    capacity: '6–12 guests',
    icon: Icons.pool,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDm1k11IbQ5cIeNtX3cZ0f3JeI3z6atDyRzJAgjG7p8kxxG4U8PG5DcX9OTNPlx1U8c7BdAaFaUARP_hN_8h_NoRmjvlFcBECYcRgvn6CdMyxyWoYxoDtlz7U1ZiqLCSjR_y75n56xJS_-6LHySNnjgzquGVsxBNi98TPPIRBmKT7Hs-NQj-Tk8qbxfSP5AkvELrVu3UjGODc_XPbmo8nEnaIaghFgQmlRGQcdMzS65Sw4qeeiJPvtEcw',
  ),
  _Facility(
    name: 'Full Resort Exclusive',
    subtitle: 'All facilities — weddings & events',
    capacity: '12–150 guests',
    icon: Icons.villa,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC4Zm2vp5vn0zdmKp9A8JaQuckcmoHcxDOQxCOkHf6EQErGnSRpxQ6eVYvtkxsMqwIBa1nv2YF--QLK8UMcci94f26t5_MdlQpY5_m-0erpz2fOPDT_CvE60s6W1xqwBHHs8ChnFpM5HsSAUJfo1DudP-Y8vsnEwlVuWpW3_pgAGt4ox0TvKNLUY612VghYUoD5_D5H83O2W1Ok6e28p2YCf-AgnWpfJbCC9PsueCJGurVp7_lg63WPfr8etugB67y1c8M',
  ),
];

const _packages = [
  _Package(
    tag: 'Day Tour',
    label: 'Day Tour',
    schedule: '9:00 AM – 5:00 PM',
    desc: 'Standard access to pools, gazebo, and shared garden facilities.',
    price: 2500,
    icon: Icons.wb_sunny,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAQtvlsjMh4ClTADR33-YJojW9di920i85A0AUViMsAZQHjVgJR3msuvCvJGJETphixQvdEVX8HLglZ5MWY2ge2P0Uc3jUivNaD5zGQyMRHtq8Mx3ZnjDfUkbfL5VMV90tzTcpSG_TTU0z2dzfn2TVV2IWkWeMgtsjd-E5kAepX1pRFlPuxWFd7NSpVtg5GBffOw9yXFC5xxS0tQWREF00U8FBXYuVJGjDv4XlwtwGNw4QxFn0hRgKssw',
    inclusions: [
      'Pool access (9 AM – 5 PM)',
      'Shared gazebo & garden',
      'Outdoor sink & BBQ area',
      'Free guest Wi-Fi',
    ],
  ),
  _Package(
    tag: 'Overnight',
    label: 'Overnight 4PM–7AM',
    schedule: '4:00 PM – 7:00 AM',
    desc: 'Overnight stay in private cabin with illuminated night pool access.',
    price: 3500,
    icon: Icons.nightlight,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCNPP3qKddOglXN2gL9tKOe0kaCeGJF2gN5mGMm7Q8pKCc_5y054nQErJ1Zq4RoboTH9O2f8xJgnNCgEOG-3BPO-JdxApGwDmXwbLhE9oldlDA3bhqesn4CtkC1uURe2DC0Fhtc5SsbQCwcoHZw0Gj0zU_d4Lviq-DhmZAyyGqn_ExZPe9h2vSrYDqeMXX5gN2uaFzcRb-s35iq_vJBEEslmR_pGdQ7_SlOnI-lB7Tmy4WDb_0Yy75u9Q',
    inclusions: [
      'Capacity: 12–15 persons',
      'All-night pool access',
      'Kids 3ft & below FREE',
      'Bonfire pit & tent area',
      'Gas stove, BBQ grill & sink',
      '2 private cabins (2 beds each)',
      'Free guest Wi-Fi',
      'Function hall access',
    ],
  ),
  _Package(
    tag: 'Extended',
    label: 'Overnight 6PM–11AM',
    schedule: '6:00 PM – 11:00 AM',
    desc: 'Extended stay with morning mountain & sunrise views.',
    price: 4000,
    icon: Icons.wb_twilight,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA2P5jJ3S9IQGQG3pRbDGvdR0-Dnwn2FxH-DIGkGoOnianaqHrt81oWzN88oC2_6hdzCuxYlr7DxAoRw1mxEjRFms8vQsK9xSyluaFem81kOPaG_KoZuw8sCLumvGIbNFkrYVOh3lnqF96n3fhlNGxr44_Lf3KhJD7V2spy6Kj4PoMJ6mSH1fd3yea0pxngAXTH3Yld8-OogiXXJFFjKi7A-MWJESL9fp8ya5cdv9xPD2aXT1yb2bvDBw',
    inclusions: [
      'Extended pool access until 11 AM',
      'Sunrise mountain view',
      '2 private cabins included',
      'BBQ grill & outdoor kitchen',
      'Free guest Wi-Fi',
      'Function hall access',
    ],
  ),
  _Package(
    tag: 'Exclusive',
    label: 'Full Resort Access',
    schedule: 'Custom schedule',
    desc: 'Ideal for weddings, debuts, corporate retreats, and reunions.',
    price: 15000,
    icon: Icons.celebration,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAZcBV6tmVum7YUkDwzW3Rl3cod8tOmLTm8NtsqADCXigxcL1JEyDl09z3fhTHUmn-pJqFEX_a8djPBrZKeFpMq66CRz4aMTyZ7h3ln-107eCF3_fWXKq4xwjXZQ_UD2Sk-WtfEKK1Su1Rsur9G8NWNyXVEW2opPQDARRUTDs0c8nYGep4d5ugaVvzkZjnZpqdN-A',
    inclusions: [
      'Full resort exclusive use',
      'All pools & facilities',
      'Grand pavilion for events',
      'Dedicated event coordinator',
      'Setup & breakdown included',
      'Free guest Wi-Fi throughout',
    ],
  ),
];

// ─── Main BookingScreen ───────────────────────────────────────────────────────

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0; // 0=Facility, 1=Package, 2=Dates, 3=Payment

  // Step 1 – Facility
  int? _selectedFacility;

  // Step 2 – Package
  int? _selectedPackage;

  // Step 3 – Dates & Guests
  DateTime _checkIn = DateTime(2026, 9, 23);
  DateTime _checkOut = DateTime(2026, 9, 24);
  int _guestCount = 4;

  // Step 4 – Add-ons & Payment
  bool _videokeAddon = false;
  bool _bbqAddon = false;
  bool _tableAddon = false;
  bool _submitting = false;

  // Step 4 – Payment method (0=GCash, 1=Bank Transfer, 2=Cash on Arrival)
  int? _selectedPaymentMethod;

  // Animation
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnim = Tween<Offset>(
            begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  double get _basePrice =>
      _selectedPackage != null ? _packages[_selectedPackage!].price : 0;

  double get _totalPrice =>
      _basePrice +
      (_videokeAddon ? 1000 : 0) +
      (_bbqAddon ? 350 : 0) +
      (_tableAddon ? 500 : 0);

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _slideCtrl.reset();
    _slideCtrl.forward();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedFacility == null) {
      _showValidationSnack('Please select a facility first');
      return;
    }
    if (_currentStep == 1 && _selectedPackage == null) {
      _showValidationSnack('Please select a package to continue');
      return;
    }
    if (_currentStep == 2) {
      // Validate: check-in must be today or later
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      final checkInOnly = DateTime(
          _checkIn.year, _checkIn.month, _checkIn.day);
      final checkOutOnly = DateTime(
          _checkOut.year, _checkOut.month, _checkOut.day);

      if (checkInOnly.isBefore(todayOnly)) {
        _showValidationSnack(
            'Check-in date cannot be in the past');
        return;
      }
      if (!checkOutOnly.isAfter(checkInOnly)) {
        _showValidationSnack(
            'Check-out must be after check-in');
        return;
      }
    }
    if (_currentStep < 3) _goToStep(_currentStep + 1);
  }

  void _prevStep() {
    if (_currentStep > 0) _goToStep(_currentStep - 1);
  }

  void _showValidationSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: AppText.bodySm),
      backgroundColor: AppColors.surfaceHigh,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  void _submitBooking() async {
    if (_selectedPaymentMethod == null) {
      _showValidationSnack('Please select a payment method');
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _submitting = false);
    const paymentLabels = ['GCash', 'Bank Transfer', 'Cash on Arrival'];
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          facility: _facilities[_selectedFacility!].name,
          package: _packages[_selectedPackage!].label,
          checkIn: _checkIn,
          checkOut: _checkOut,
          guests: _guestCount,
          total: _totalPrice,
          paymentMethod: paymentLabels[_selectedPaymentMethod!],
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  static const _stepLabels = ['Facility', 'Package', 'Dates', 'Payment'];

  static const _stepIcons = [
    Icons.villa,
    Icons.hotel_class,
    Icons.calendar_month,
    Icons.payments,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildStepIndicator(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: SlideTransition(
                  key: ValueKey(_currentStep),
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: ConciergeFab(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    final titles = [
      'Select Facility',
      'Choose Package',
      'Pick Dates & Guests',
      'Add-ons & Payment',
    ];
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _currentStep == 0 ? Icons.close : Icons.arrow_back,
              color: AppColors.onSurface,
            ),
            onPressed: _currentStep == 0
                ? () => Navigator.of(context).pop()
                : _prevStep,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book A Stay',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.secondary, letterSpacing: 1.0),
                ),
                Text(
                  titles[_currentStep],
                  style: AppText.titleMd
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          // Live price badge (steps 2+)
          if (_currentStep >= 1 && _selectedPackage != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.secondary.withOpacity(0.4)),
              ),
              child: Text(
                '₱${_totalPrice.toStringAsFixed(0)}',
                style: AppText.labelMd.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ── Step indicator ─────────────────────────────────────────────────────────

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        border: Border(
            bottom: BorderSide(
                color: AppColors.outlineVariant.withOpacity(0.3))),
      ),
      child: Row(
        children: List.generate(_stepLabels.length, (i) {
          final done = i < _currentStep;
          final active = i == _currentStep;
          final upcoming = i > _currentStep;

          return Expanded(
            child: Row(
              children: [
                // Dot + label
                GestureDetector(
                  onTap: done ? () => _goToStep(i) : null,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done
                              ? AppColors.primary
                              : active
                                  ? AppColors.secondary
                                  : AppColors.surfaceHighest,
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: AppColors.secondary
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: done
                              ? const Icon(Icons.check,
                                  size: 16,
                                  color: AppColors.onPrimary)
                              : Icon(
                                  _stepIcons[i],
                                  size: 16,
                                  color: active
                                      ? AppColors.onSecondary
                                      : AppColors.onSurfaceVariant,
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _stepLabels[i],
                        style: AppText.labelSm.copyWith(
                          color: done
                              ? AppColors.primary
                              : active
                                  ? AppColors.secondary
                                  : AppColors.onSurfaceVariant,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                // Connector line (not after last)
                if (i < _stepLabels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: i < _currentStep
                              ? [AppColors.primary, AppColors.primary]
                              : [
                                  AppColors.surfaceHighest,
                                  AppColors.surfaceHighest
                                ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Step router ────────────────────────────────────────────────────────────

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _StepFacility(
          facilities: _facilities,
          selectedIndex: _selectedFacility,
          onSelect: (i) => setState(() => _selectedFacility = i),
        );
      case 1:
        return _StepPackage(
          packages: _packages,
          selectedIndex: _selectedPackage,
          onSelect: (i) => setState(() => _selectedPackage = i),
        );
      case 2:
        return _StepDates(
          checkIn: _checkIn,
          checkOut: _checkOut,
          guestCount: _guestCount,
          selectedPackage: _selectedPackage != null
              ? _packages[_selectedPackage!]
              : null,
          onCheckInChanged: (d) => setState(() => _checkIn = d),
          onCheckOutChanged: (d) => setState(() => _checkOut = d),
          onGuestCountChanged: (n) => setState(() => _guestCount = n),
        );
      case 3:
        return _StepPayment(
          facility: _selectedFacility != null
              ? _facilities[_selectedFacility!]
              : null,
          package: _selectedPackage != null
              ? _packages[_selectedPackage!]
              : null,
          checkIn: _checkIn,
          checkOut: _checkOut,
          guestCount: _guestCount,
          videokeAddon: _videokeAddon,
          bbqAddon: _bbqAddon,
          tableAddon: _tableAddon,
          onVideokeChanged: (v) => setState(() => _videokeAddon = v),
          onBbqChanged: (v) => setState(() => _bbqAddon = v),
          onTableChanged: (v) => setState(() => _tableAddon = v),
          totalPrice: _totalPrice,
          selectedPaymentMethod: _selectedPaymentMethod,
          onPaymentMethodChanged: (i) =>
              setState(() => _selectedPaymentMethod = i),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Bottom action bar ──────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    String btnLabel;
    switch (_currentStep) {
      case 0:
        btnLabel = _selectedFacility != null
            ? 'Continue to Package →'
            : 'Select a Facility';
        break;
      case 1:
        btnLabel = _selectedPackage != null
            ? 'Continue to Dates →'
            : 'Select a Package';
        break;
      case 2:
        btnLabel = 'Continue to Payment →';
        break;
      case 3:
        btnLabel = _selectedPaymentMethod != null
            ? 'Confirm & Pay ₱1,000 Downpayment'
            : 'Select a Payment Method';
        break;
      default:
        btnLabel = 'Continue';
    }

    final canProceed = (_currentStep == 0 && _selectedFacility != null) ||
        (_currentStep == 1 && _selectedPackage != null) ||
        _currentStep == 2 ||
        (_currentStep == 3 && _selectedPaymentMethod != null);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button (steps 1+)
          if (_currentStep > 0) ...[
            GestureDetector(
              onTap: _prevStep,
              child: Container(
                width: 48,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.outlineVariant.withOpacity(0.4)),
                ),
                child: const Icon(Icons.arrow_back,
                    color: AppColors.onSurface, size: 22),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Primary CTA
          Expanded(
            child: AnimatedOpacity(
              opacity: canProceed ? 1.0 : 0.55,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: _currentStep == 3 ? _submitBooking : _nextStep,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: canProceed
                        ? const LinearGradient(
                            colors: [
                              AppColors.primaryContainer,
                              AppColors.primary,
                            ],
                          )
                        : null,
                    color: canProceed
                        ? null
                        : AppColors.surfaceHighest,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: canProceed
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: _submitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: AppColors.onPrimary,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            btnLabel,
                            style: AppText.labelLg.copyWith(
                              color: canProceed
                                  ? AppColors.onPrimary
                                  : AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1 – Facility Selection ──────────────────────────────────────────────

class _StepFacility extends StatelessWidget {
  final List<_Facility> facilities;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const _StepFacility({
    required this.facilities,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              const Icon(Icons.villa, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STEP 1 OF 4',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.primary, letterSpacing: 1.5)),
                  Text('Choose Your Facility',
                      style: AppText.headlineSm
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Select the space you want to reserve at A&D Thysia Resort.',
            style: AppText.bodySm
                .copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 20),
          // Facility cards
          ...List.generate(facilities.length, (i) {
            final f = facilities[i];
            final selected = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.outlineVariant.withOpacity(0.3),
                      width: selected ? 2 : 1,
                    ),
                    color: selected
                        ? AppColors.primary.withOpacity(0.06)
                        : AppColors.surfaceContainer,
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(19),
                          bottomLeft: Radius.circular(19),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: f.imageUrl,
                          width: 100,
                          height: 90,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 100,
                            height: 90,
                            color: AppColors.surfaceHigh,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 100,
                            height: 90,
                            color: AppColors.surfaceHigh,
                            child: Icon(f.icon,
                                size: 32,
                                color: AppColors.onSurfaceVariant),
                          ),
                        ),
                      ),
                      // Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f.name,
                                  style: AppText.labelLg.copyWith(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Text(f.subtitle,
                                  style: AppText.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.people_outline,
                                      size: 13,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(f.capacity,
                                      style: AppText.labelSm.copyWith(
                                          color: selected
                                              ? AppColors.primary
                                              : AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Check badge
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? AppColors.primary
                                : AppColors.surfaceHighest,
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.outlineVariant
                                      .withOpacity(0.4),
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check,
                                  size: 16,
                                  color: AppColors.onPrimary)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── Step 2 – Package Selection ───────────────────────────────────────────────

class _StepPackage extends StatelessWidget {
  final List<_Package> packages;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const _StepPackage({
    required this.packages,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hotel_class,
                  size: 18, color: AppColors.secondary),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STEP 2 OF 4',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.secondary,
                          letterSpacing: 1.5)),
                  Text('Choose a Package',
                      style: AppText.headlineSm
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Select the schedule & experience that best fits your stay.',
            style: AppText.bodySm
                .copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 20),
          // Package cards
          ...List.generate(packages.length, (i) {
            final p = packages[i];
            final selected = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.outlineVariant.withOpacity(0.3),
                      width: selected ? 2 : 1,
                    ),
                    color: selected
                        ? AppColors.primary.withOpacity(0.05)
                        : AppColors.surfaceContainer,
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.18),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image + tag
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(19),
                          topRight: Radius.circular(19),
                        ),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: p.imageUrl,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                  height: 130,
                                  color: AppColors.surfaceHigh),
                              errorWidget: (_, __, ___) => Container(
                                height: 130,
                                color: AppColors.surfaceHigh,
                                child: Center(
                                    child: Icon(p.icon,
                                        size: 36,
                                        color:
                                            AppColors.onSurfaceVariant)),
                              ),
                            ),
                            // Gradient overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      (selected
                                              ? AppColors.surfaceContainer
                                              : AppColors.surfaceContainer)
                                          .withOpacity(0.85),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Tag pill
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.surfaceLowest
                                          .withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(p.tag,
                                    style: AppText.labelSm.copyWith(
                                        color: selected
                                            ? AppColors.onPrimary
                                            : AppColors.onSurface,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            // Check badge
                            if (selected)
                              const Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.primary,
                                  child: Icon(Icons.check,
                                      size: 16,
                                      color: AppColors.onPrimary),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Info
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(p.icon,
                                        size: 14,
                                        color: AppColors.secondary),
                                    const SizedBox(width: 5),
                                    Text(p.schedule,
                                        style: AppText.labelSm.copyWith(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Text('₱${p.price.toStringAsFixed(0)}',
                                    style: AppText.titleMd.copyWith(
                                        color: selected
                                            ? AppColors.secondary
                                            : AppColors.onSurface,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(p.desc,
                                style: AppText.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    height: 1.4)),
                            // Inclusions preview (when selected)
                            if (selected) ...[
                              const SizedBox(height: 10),
                              Divider(
                                  color: AppColors.outlineVariant
                                      .withOpacity(0.3)),
                              const SizedBox(height: 8),
                              Text('What\'s included:',
                                  style: AppText.labelMd.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: p.inclusions
                                    .map((inc) => Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    8),
                                          ),
                                          child: Row(
                                            mainAxisSize:
                                                MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                  Icons.check_circle,
                                                  size: 11,
                                                  color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(inc,
                                                  style: AppText.labelSm
                                                      .copyWith(
                                                          color: AppColors
                                                              .primary)),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── Step 3 – Dates & Guests ──────────────────────────────────────────────────

class _StepDates extends StatefulWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final int guestCount;
  final _Package? selectedPackage;
  final ValueChanged<DateTime> onCheckInChanged;
  final ValueChanged<DateTime> onCheckOutChanged;
  final ValueChanged<int> onGuestCountChanged;

  const _StepDates({
    required this.checkIn,
    required this.checkOut,
    required this.guestCount,
    required this.selectedPackage,
    required this.onCheckInChanged,
    required this.onCheckOutChanged,
    required this.onGuestCountChanged,
  });

  @override
  State<_StepDates> createState() => _StepDatesState();
}

class _StepDatesState extends State<_StepDates> {
  // Local copies so we can validate before bubbling up
  late DateTime _checkIn;
  late DateTime _checkOut;

  // Validation state
  String? _checkInError;
  String? _checkOutError;
  bool _checkInTouched = false;
  bool _checkOutTouched = false;

  @override
  void initState() {
    super.initState();
    _checkIn = widget.checkIn;
    _checkOut = widget.checkOut;
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  static const _monthsFull = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _monthsShort = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _weekdays = [
    '', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  String _fmtFull(DateTime d) =>
      '${_monthsShort[d.month]} ${d.day}, ${d.year}';
  String _fmtDay(DateTime d) => '${_weekdays[d.weekday]}, ${d.day} ${_monthsFull[d.month]} ${d.year}';

  int get _nights {
    final diff = _checkOut
        .difference(DateTime(_checkIn.year, _checkIn.month, _checkIn.day))
        .inDays;
    return diff > 0 ? diff : 0;
  }

  // ── validation ────────────────────────────────────────────────────────────

  String? _validateCheckIn(DateTime d) {
    final today = DateTime.now();
    final todayOnly =
        DateTime(today.year, today.month, today.day);
    final picked = DateTime(d.year, d.month, d.day);
    if (picked.isBefore(todayOnly)) {
      return 'Check-in cannot be in the past';
    }
    return null;
  }

  String? _validateCheckOut(DateTime ci, DateTime co) {
    final ciOnly = DateTime(ci.year, ci.month, ci.day);
    final coOnly = DateTime(co.year, co.month, co.day);
    if (!coOnly.isAfter(ciOnly)) {
      return 'Check-out must be after check-in';
    }
    return null;
  }

  bool get _isValid =>
      _validateCheckIn(_checkIn) == null &&
      _validateCheckOut(_checkIn, _checkOut) == null;

  // ── pick check-in ─────────────────────────────────────────────────────────

  Future<void> _pickCheckIn() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn.isBefore(today) ? today : _checkIn,
      firstDate: today,
      lastDate: DateTime(2027, 12, 31),
      helpText: 'SELECT CHECK-IN DATE',
      builder: _calendarTheme,
    );
    if (picked == null) return;

    setState(() {
      _checkInTouched = true;
      _checkIn = picked;
      _checkInError = _validateCheckIn(picked);

      // Auto-advance check-out to next day if it no longer trails check-in
      if (!_checkOut.isAfter(picked)) {
        _checkOut = picked.add(const Duration(days: 1));
        _checkOutError = null;
      }
      _checkOutError = _validateCheckOut(_checkIn, _checkOut);
    });

    widget.onCheckInChanged(_checkIn);
    widget.onCheckOutChanged(_checkOut);
  }

  // ── pick check-out ────────────────────────────────────────────────────────

  Future<void> _pickCheckOut() async {
    final minOut = _checkIn.add(const Duration(days: 1));
    final initOut = _checkOut.isAfter(_checkIn) ? _checkOut : minOut;

    final picked = await showDatePicker(
      context: context,
      initialDate: initOut,
      firstDate: minOut,
      lastDate: DateTime(2027, 12, 31),
      helpText: 'SELECT CHECK-OUT DATE',
      builder: _calendarTheme,
    );
    if (picked == null) return;

    setState(() {
      _checkOutTouched = true;
      _checkOut = picked;
      _checkOutError = _validateCheckOut(_checkIn, picked);
    });

    widget.onCheckOutChanged(_checkOut);
  }

  Widget _calendarTheme(BuildContext ctx, Widget? child) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.surfaceContainer,
          onSurface: AppColors.onSurface,
          secondary: AppColors.secondary,
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.surfaceContainer,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: AppColors.primary),
        ),
      ),
      child: child!,
    );
  }

  String _checkInTime() {
    if (widget.selectedPackage == null) return '4:00 PM';
    if (widget.selectedPackage!.icon == Icons.wb_sunny) return '9:00 AM';
    if (widget.selectedPackage!.icon == Icons.wb_twilight) return '6:00 PM';
    return '4:00 PM';
  }

  String _checkOutTime() {
    if (widget.selectedPackage == null) return '7:00 AM';
    if (widget.selectedPackage!.icon == Icons.wb_sunny) return '5:00 PM';
    if (widget.selectedPackage!.icon == Icons.wb_twilight) return '11:00 AM';
    return '7:00 AM';
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              const Icon(Icons.calendar_month,
                  size: 18, color: AppColors.tertiary),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STEP 3 OF 4',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.tertiary,
                          letterSpacing: 1.5)),
                  Text('Dates & Guests',
                      style: AppText.headlineSm
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tap each card to pick your check-in and check-out dates.',
            style: AppText.bodySm.copyWith(
                color: AppColors.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 20),

          // Package chip
          if (widget.selectedPackage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.selectedPackage!.label} • ${widget.selectedPackage!.schedule}',
                      style: AppText.labelMd.copyWith(
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '₱${widget.selectedPackage!.price.toStringAsFixed(0)}',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Duration summary banner
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isValid
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.errorContainer.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isValid
                    ? AppColors.primary.withOpacity(0.25)
                    : AppColors.error.withOpacity(0.35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isValid ? Icons.bedtime_outlined : Icons.warning_amber,
                  size: 20,
                  color: _isValid
                      ? AppColors.primary
                      : AppColors.error,
                ),
                const SizedBox(width: 8),
                Text(
                  _isValid
                      ? '$_nights night${_nights != 1 ? "s" : ""} • ${_fmtFull(_checkIn)} → ${_fmtFull(_checkOut)}'
                      : 'Fix date errors below to continue',
                  style: AppText.labelMd.copyWith(
                    color: _isValid
                        ? AppColors.primary
                        : AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Check-in card ───────────────────────────────────────────────
          Text('CHECK-IN DATE',
              style: AppText.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _PickerCard(
            label: 'Tap to select check-in',
            dateText: _checkInTouched ? _fmtDay(_checkIn) : null,
            timeText: _checkInTime(),
            icon: Icons.login,
            accentColor: AppColors.primary,
            hasError: _checkInTouched && _checkInError != null,
            onTap: _pickCheckIn,
          ),
          // Check-in error
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _checkInTouched && _checkInError != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 13, color: AppColors.error),
                        const SizedBox(width: 5),
                        Text(_checkInError!,
                            style: AppText.labelSm
                                .copyWith(color: AppColors.error)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          // ── Check-out card ──────────────────────────────────────────────
          Text('CHECK-OUT DATE',
              style: AppText.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _PickerCard(
            label: 'Tap to select check-out',
            dateText: _checkOutTouched ? _fmtDay(_checkOut) : null,
            timeText: _checkOutTime(),
            icon: Icons.logout,
            accentColor: AppColors.secondary,
            hasError: _checkOutTouched && _checkOutError != null,
            onTap: _pickCheckOut,
          ),
          // Check-out error
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _checkOutTouched && _checkOutError != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 13, color: AppColors.error),
                        const SizedBox(width: 5),
                        Text(_checkOutError!,
                            style: AppText.labelSm
                                .copyWith(color: AppColors.error)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Validation rule list ────────────────────────────────────────
          const SizedBox(height: 16),
          _ValidationRulesCard(
            checkInSet: _checkInTouched,
            checkOutSet: _checkOutTouched,
            checkInValid: _checkInError == null,
            checkOutValid: _checkOutError == null,
            nights: _nights,
          ),

          const SizedBox(height: 20),

          // ── Guest stepper ───────────────────────────────────────────────
          Text('TOTAL GUESTS',
              style: AppText.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Number of Guests',
                        style: AppText.labelMd.copyWith(
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('Maximum 15 guests per booking',
                        style: AppText.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant)),
                  ],
                ),
                Row(
                  children: [
                    _StepperBtn(
                      icon: Icons.remove,
                      onTap: widget.guestCount > 1
                          ? () => widget
                              .onGuestCountChanged(widget.guestCount - 1)
                          : null,
                      color: AppColors.surfaceHigh,
                    ),
                    Container(
                      width: 52,
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.guestCount}',
                        style: AppText.headlineMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 26),
                      ),
                    ),
                    _StepperBtn(
                      icon: Icons.add,
                      onTap: widget.guestCount < 15
                          ? () => widget
                              .onGuestCountChanged(widget.guestCount + 1)
                          : null,
                      color: AppColors.primary,
                      iconColor: AppColors.onPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Guest capacity bar
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.guestCount / 15,
              backgroundColor: AppColors.surfaceHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.guestCount >= 13
                    ? AppColors.secondary
                    : AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.guestCount} guests selected',
                  style: AppText.labelSm.copyWith(
                      color: widget.guestCount >= 13
                          ? AppColors.secondary
                          : AppColors.primary,
                      fontWeight: FontWeight.w600)),
              Text('${15 - widget.guestCount} spots remaining',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant)),
            ],
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── Picker card widget ───────────────────────────────────────────────────────

class _PickerCard extends StatelessWidget {
  final String label;
  final String? dateText;
  final String timeText;
  final IconData icon;
  final Color accentColor;
  final bool hasError;
  final VoidCallback onTap;

  const _PickerCard({
    required this.label,
    required this.dateText,
    required this.timeText,
    required this.icon,
    required this.accentColor,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = dateText != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasError
              ? AppColors.errorContainer.withOpacity(0.1)
              : hasDate
                  ? accentColor.withOpacity(0.07)
                  : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasError
                ? AppColors.error.withOpacity(0.5)
                : hasDate
                    ? accentColor.withOpacity(0.5)
                    : AppColors.outlineVariant.withOpacity(0.4),
            width: hasDate || hasError ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasError
                    ? AppColors.error.withOpacity(0.12)
                    : hasDate
                        ? accentColor.withOpacity(0.15)
                        : AppColors.surfaceHighest,
              ),
              child: Icon(
                hasError ? Icons.error_outline : icon,
                size: 22,
                color: hasError
                    ? AppColors.error
                    : hasDate
                        ? accentColor
                        : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!hasDate)
                    Text(label,
                        style: AppText.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant
                                .withOpacity(0.6)))
                  else ...[
                    Text(dateText!,
                        style: AppText.labelLg.copyWith(
                            color: hasError
                                ? AppColors.error
                                : AppColors.onSurface,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 11,
                            color: accentColor.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        Text(timeText,
                            style: AppText.labelSm.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Calendar tap indicator
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: hasDate
                    ? accentColor.withOpacity(0.15)
                    : AppColors.surfaceHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    hasDate ? Icons.edit_calendar : Icons.calendar_today,
                    size: 15,
                    color:
                        hasDate ? accentColor : AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hasDate ? 'Change' : 'Pick',
                    style: AppText.labelSm.copyWith(
                        color: hasDate
                            ? accentColor
                            : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Validation rules card ────────────────────────────────────────────────────

class _ValidationRulesCard extends StatelessWidget {
  final bool checkInSet;
  final bool checkOutSet;
  final bool checkInValid;
  final bool checkOutValid;
  final int nights;

  const _ValidationRulesCard({
    required this.checkInSet,
    required this.checkOutSet,
    required this.checkInValid,
    required this.checkOutValid,
    required this.nights,
  });

  @override
  Widget build(BuildContext context) {
    final rules = [
      _Rule(
        label: 'Check-in must be today or a future date',
        passed: checkInSet && checkInValid,
        failed: checkInSet && !checkInValid,
      ),
      _Rule(
        label: 'Check-out must be after check-in',
        passed: checkOutSet && checkOutValid,
        failed: checkOutSet && !checkOutValid,
      ),
      _Rule(
        label: 'Both dates must be selected',
        passed: checkInSet && checkOutSet,
        failed: false,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.rule,
                  size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              Text('Date Requirements',
                  style: AppText.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          ...rules.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: r.passed
                            ? AppColors.primary.withOpacity(0.2)
                            : r.failed
                                ? AppColors.error.withOpacity(0.2)
                                : AppColors.surfaceHighest,
                      ),
                      child: Icon(
                        r.passed
                            ? Icons.check
                            : r.failed
                                ? Icons.close
                                : Icons.circle_outlined,
                        size: 12,
                        color: r.passed
                            ? AppColors.primary
                            : r.failed
                                ? AppColors.error
                                : AppColors.outlineVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(r.label,
                        style: AppText.bodySm.copyWith(
                          color: r.passed
                              ? AppColors.primary
                              : r.failed
                                  ? AppColors.error
                                  : AppColors.onSurfaceVariant,
                        )),
                  ],
                ),
              )),
          // Duration info when valid
          if (checkInSet && checkOutSet && checkInValid && checkOutValid) ...[
            Divider(
                height: 14,
                color: AppColors.outlineVariant.withOpacity(0.3)),
            Row(
              children: [
                const Icon(Icons.nights_stay,
                    size: 14, color: AppColors.tertiary),
                const SizedBox(width: 6),
                Text(
                  'Duration: $nights night${nights != 1 ? "s" : ""}',
                  style: AppText.labelMd.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Rule {
  final String label;
  final bool passed;
  final bool failed;
  const _Rule({
    required this.label,
    required this.passed,
    required this.failed,
  });
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final Color iconColor;

  const _StepperBtn({
    required this.icon,
    required this.onTap,
    required this.color,
    this.iconColor = AppColors.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap != null ? 1.0 : 0.35,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}

// ─── Step 4 – Add-ons & Payment ───────────────────────────────────────────────

class _StepPayment extends StatelessWidget {
  final _Facility? facility;
  final _Package? package;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guestCount;
  final bool videokeAddon;
  final bool bbqAddon;
  final bool tableAddon;
  final ValueChanged<bool> onVideokeChanged;
  final ValueChanged<bool> onBbqChanged;
  final ValueChanged<bool> onTableChanged;
  final double totalPrice;
  final int? selectedPaymentMethod;
  final ValueChanged<int> onPaymentMethodChanged;

  const _StepPayment({
    required this.facility,
    required this.package,
    required this.checkIn,
    required this.checkOut,
    required this.guestCount,
    required this.videokeAddon,
    required this.bbqAddon,
    required this.tableAddon,
    required this.onVideokeChanged,
    required this.onBbqChanged,
    required this.onTableChanged,
    required this.totalPrice,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  String _fmt(DateTime d) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.payments,
                  size: 18, color: AppColors.goldAccent),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STEP 4 OF 4',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.goldAccent, letterSpacing: 1.5)),
                  Text('Add-ons & Payment',
                      style: AppText.headlineSm
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Review your booking, add extras, choose how to pay, then confirm.',
            style: AppText.bodySm
                .copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 20),

          // ── Booking summary ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Summary',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
                const SizedBox(height: 12),
                _summaryRow(Icons.villa, 'Facility',
                    facility?.name ?? '—', AppColors.primary),
                const SizedBox(height: 8),
                _summaryRow(Icons.hotel_class, 'Package',
                    package?.label ?? '—', AppColors.secondary),
                const SizedBox(height: 8),
                _summaryRow(Icons.calendar_today, 'Dates',
                    '${_fmt(checkIn)} – ${_fmt(checkOut)}',
                    AppColors.tertiary),
                const SizedBox(height: 8),
                _summaryRow(Icons.people, 'Guests',
                    '$guestCount guests', AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Add-ons ──────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.add_circle_outline,
                            size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text('Resort Add-ons',
                            style: AppText.labelMd.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Text('Optional',
                        style: AppText.labelSm
                            .copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 12),
                _AddonRow(
                  icon: Icons.mic,
                  title: 'Videoke Machine & Sound System',
                  subtitle: 'Unlimited songs until 10:00 PM',
                  price: '+₱1,000',
                  checked: videokeAddon,
                  onChanged: onVideokeChanged,
                ),
                const SizedBox(height: 8),
                _AddonRow(
                  icon: Icons.outdoor_grill,
                  title: 'Heavy-Duty Charcoal BBQ Grill Kit',
                  subtitle: 'Includes 2 packs of premium charcoal',
                  price: '+₱350',
                  checked: bbqAddon,
                  onChanged: onBbqChanged,
                ),
                const SizedBox(height: 8),
                _AddonRow(
                  icon: Icons.table_bar,
                  title: 'Extra Long Table & 10 Chairs',
                  subtitle: 'Pre-arranged at function pavilion',
                  price: '+₱500',
                  checked: tableAddon,
                  onChanged: onTableChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Payment method picker ────────────────────────────────────────────
          _PaymentMethodSection(
            selected: selectedPaymentMethod,
            onChanged: onPaymentMethodChanged,
          ),
          const SizedBox(height: 16),

          // ── Cost breakdown ───────────────────────────────────────────────────
          _CostBreakdownCard(
            package: package,
            videokeAddon: videokeAddon,
            bbqAddon: bbqAddon,
            tableAddon: tableAddon,
            totalPrice: totalPrice,
            selectedPaymentMethod: selectedPaymentMethod,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _summaryRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppText.labelSm
                    .copyWith(color: AppColors.onSurfaceVariant)),
            Text(value,
                style: AppText.labelMd
                    .copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

// ─── Payment method data ──────────────────────────────────────────────────────

class _PaymentMethodData {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> instructions;
  const _PaymentMethodData({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.instructions,
  });
}

const _paymentMethods = [
  _PaymentMethodData(
    name: 'GCash',
    subtitle: 'Pay via GCash QR or mobile number',
    icon: Icons.account_balance_wallet,
    color: Color(0xFF007DC5),
    instructions: [
      'Open your GCash app',
      'Tap "Send Money" or scan the QR code',
      'Amount: ₱1,000 downpayment',
      'Send screenshot to our FB page as proof',
    ],
  ),
  _PaymentMethodData(
    name: 'Bank Transfer',
    subtitle: 'BDO, BPI, UnionBank, Maya',
    icon: Icons.account_balance,
    color: Color(0xFF10B981),
    instructions: [
      'Bank: BDO / BPI / UnionBank / Maya',
      'Account Name: A&D Thysia Resort',
      'Account No: XXXX-XXXX-XXXX',
      'Amount: ₱1,000 downpayment',
      'Send deposit slip to our FB page as proof',
    ],
  ),
  _PaymentMethodData(
    name: 'Cash on Arrival',
    subtitle: 'Pay full amount upon check-in',
    icon: Icons.payments_outlined,
    color: Color(0xFFFFB95F),
    instructions: [
      'No upfront payment needed',
      'Pay full amount upon arrival',
      'Please bring exact change if possible',
      'Reservation may require a hold fee for large groups',
    ],
  ),
];

// ─── Payment method section ───────────────────────────────────────────────────

class _PaymentMethodSection extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onChanged;

  const _PaymentMethodSection({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const Icon(Icons.credit_card,
                size: 18, color: AppColors.goldAccent),
            const SizedBox(width: 8),
            Text('Payment Method',
                style: AppText.labelLg.copyWith(
                    fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            // Required badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.error.withOpacity(0.35)),
              ),
              child: Text('Required',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Choose how you will pay the reservation deposit.',
          style: AppText.bodySm
              .copyWith(color: AppColors.onSurfaceVariant, height: 1.4),
        ),
        const SizedBox(height: 12),

        // Method cards
        ...List.generate(_paymentMethods.length, (i) {
          final m = _paymentMethods[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PaymentMethodCard(
              method: m,
              isSelected: selected == i,
              onTap: () => onChanged(i),
            ),
          );
        }),

        // Hint shown until something is selected
        if (selected == null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 13, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 5),
                Text(
                  'Select a payment method to enable the Confirm button',
                  style: AppText.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Payment method card ──────────────────────────────────────────────────────

class _PaymentMethodCard extends StatefulWidget {
  final _PaymentMethodData method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<_PaymentMethodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));
    _anim =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.isSelected) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant _PaymentMethodCard old) {
    super.didUpdateWidget(old);
    if (widget.isSelected != old.isSelected) {
      widget.isSelected ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.method;
    final sel = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: sel
              ? m.color.withOpacity(0.08)
              : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: sel ? m.color : AppColors.outlineVariant.withOpacity(0.3),
            width: sel ? 2 : 1,
          ),
          boxShadow: sel
              ? [
                  BoxShadow(
                    color: m.color.withOpacity(0.20),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // ── Header row ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Icon circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: m.color.withOpacity(sel ? 0.18 : 0.12),
                      border: Border.all(
                          color: m.color.withOpacity(0.35)),
                    ),
                    child: Icon(m.icon, size: 22, color: m.color),
                  ),
                  const SizedBox(width: 14),
                  // Name + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: AppText.labelLg.copyWith(
                            color: sel ? m.color : AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(m.subtitle,
                            style: AppText.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  // Radio circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sel ? m.color : Colors.transparent,
                      border: Border.all(
                        color: sel ? m.color : AppColors.outlineVariant,
                        width: 2,
                      ),
                    ),
                    child: sel
                        ? const Icon(Icons.check,
                            size: 13, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),

            // ── Expandable instructions ────────────────────────────────────────
            SizeTransition(
              sizeFactor: _anim,
              axisAlignment: -1,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: m.color.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: m.color.withOpacity(0.22)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 13, color: m.color),
                        const SizedBox(width: 5),
                        Text(
                          'How to pay',
                          style: AppText.labelSm.copyWith(
                              color: m.color,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...m.instructions.asMap().entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 19,
                              height: 19,
                              margin: const EdgeInsets.only(
                                  right: 8, top: 1),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: m.color.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Text(
                                  '${e.key + 1}',
                                  style: AppText.labelSm.copyWith(
                                      color: m.color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                e.value,
                                style: AppText.bodySm.copyWith(
                                    color: AppColors.onSurface
                                        .withOpacity(0.85),
                                    height: 1.45),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cost breakdown card ──────────────────────────────────────────────────────

class _CostBreakdownCard extends StatelessWidget {
  final _Package? package;
  final bool videokeAddon;
  final bool bbqAddon;
  final bool tableAddon;
  final double totalPrice;
  final int? selectedPaymentMethod;

  const _CostBreakdownCard({
    required this.package,
    required this.videokeAddon,
    required this.bbqAddon,
    required this.tableAddon,
    required this.totalPrice,
    required this.selectedPaymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final sel = selectedPaymentMethod;
    final isCash = sel == 2;
    final methodName = sel != null ? _paymentMethods[sel].name : null;
    final methodColor =
        sel != null ? _paymentMethods[sel].color : AppColors.secondary;

    final depositLabel = isCash
        ? 'Full amount due on arrival'
        : '₱1,000 deposit required';
    final depositNote = isCash
        ? 'Pay ₱${totalPrice.toStringAsFixed(0)} in full when you arrive at A&D Thysia Resort. No upfront payment needed.'
        : sel != null
            ? 'Pay ₱1,000 via ${methodName!} to lock your reservation. Balance of ₱${(totalPrice - 1000).toStringAsFixed(0)} is due upon check-in. Strictly non-refundable.'
            : 'Select a payment method above to see deposit details.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cost Breakdown',
                  style: AppText.headlineSm
                      .copyWith(fontWeight: FontWeight.w600)),
              Text('Transparent Pricing',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          _costRow(package?.label ?? 'Stay',
              '₱${package?.price.toStringAsFixed(0) ?? "0"}'),
          if (videokeAddon) _costRow('Videoke Rental', '₱1,000'),
          if (bbqAddon) _costRow('BBQ Grill Kit', '₱350'),
          if (tableAddon) _costRow('Table & Chairs', '₱500'),
          _costRow('Resort Maintenance', 'FREE',
              color: AppColors.primary),
          Divider(
              height: 20,
              color: AppColors.surfaceHighest,
              thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Stay Cost',
                  style: AppText.titleMd
                      .copyWith(fontWeight: FontWeight.w700)),
              Text(
                '₱${totalPrice.toStringAsFixed(0)}',
                style: AppText.headlineMd.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 28),
              ),
            ],
          ),
          // Deposit row (only if not cash)
          if (sel != null && !isCash) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Deposit to Pay Now',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant)),
                Text('₱1,000',
                    style: AppText.labelLg.copyWith(
                        color: methodColor,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance on Check-in',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant)),
                Text('₱${(totalPrice - 1000).toStringAsFixed(0)}',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
          const SizedBox(height: 12),

          // Payment notice box — updates based on selection
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: sel != null
                  ? methodColor.withOpacity(0.08)
                  : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: sel != null
                    ? methodColor.withOpacity(0.30)
                    : AppColors.outlineVariant.withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  sel != null
                      ? _paymentMethods[sel].icon
                      : Icons.verified_user,
                  size: 20,
                  color: methodColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sel != null
                            ? '$methodName: $depositLabel'
                            : 'No payment method selected',
                        style: AppText.labelMd
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        depositNote,
                        style: AppText.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _costRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppText.bodySm
                  .copyWith(color: AppColors.onSurfaceVariant)),
          Text(value,
              style: AppText.bodySm.copyWith(
                  color: color ?? AppColors.onSurface,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Add-on row ───────────────────────────────────────────────────────────────

class _AddonRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String price;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const _AddonRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: checked
              ? AppColors.primary.withOpacity(0.07)
              : AppColors.surfaceHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: checked
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.outlineVariant.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:
                    checked ? AppColors.primary : AppColors.surfaceHighest,
              ),
              child: checked
                  ? const Icon(Icons.check,
                      size: 14, color: AppColors.onPrimary)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.labelMd
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: AppText.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            Text(price,
                style: AppText.labelMd.copyWith(
                    color: checked
                        ? AppColors.secondary
                        : AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}


