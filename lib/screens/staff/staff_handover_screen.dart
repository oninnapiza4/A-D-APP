import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_theme.dart';
import 'staff_rfid_screen.dart';

class StaffHandoverScreen extends StatefulWidget {
  final StaffMember staff;
  const StaffHandoverScreen({super.key, required this.staff});

  @override
  State<StaffHandoverScreen> createState() => _StaffHandoverScreenState();
}

class _StaffHandoverScreenState extends State<StaffHandoverScreen> {
  final _noteCtrl = TextEditingController(
    text:
        'VIP guest arriving at Villa 2 at 10:30 AM requested extra lemongrass towels and iced hibiscus tea. Front deck patio cushions sanitized.',
  );
  final _newTaskCtrl = TextEditingController();
  bool _submitted = false;
  bool _submitting = false;

  final List<_Task> _tasks = [
    _Task('Confirm catering delivery', false),
    _Task('Return poolside radio', false),
  ];

  @override
  void dispose() {
    _noteCtrl.dispose();
    _newTaskCtrl.dispose();
    super.dispose();
  }

  int get _pendingCount => _tasks.where((t) => !t.done).length;

  void _addTask() {
    final v = _newTaskCtrl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      _tasks.add(_Task(v, false));
      _newTaskCtrl.clear();
    });
  }

  void _submitHandover() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
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
                      _buildShiftHeroCard(),
                      const SizedBox(height: 14),
                      _buildReferenceCard(),
                      const SizedBox(height: 14),
                      _buildPendingTasks(),
                      const SizedBox(height: 14),
                      _buildSubmitSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  color: AppColors.onSurfaceVariant)),
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
                  size: 14, color: AppColors.onSurfaceVariant),
              SizedBox(width: 4),
              Icon(Icons.wifi,
                  size: 14, color: AppColors.onSurfaceVariant),
              SizedBox(width: 4),
              Icon(Icons.battery_full,
                  size: 14, color: AppColors.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 12, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text('WEDNESDAY, 23 SEPTEMBER 2026',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 1.0)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Shift Handover',
                  style: AppText.headlineMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface)),
              const SizedBox(height: 4),
              Text('Help the next team member start with confidence',
                  style: AppText.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.staff.rfidCode} • ${widget.staff.name} • Handover Active',
                    style: AppText.labelSm.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.secondary,
                AppColors.secondaryContainer,
                AppColors.surfaceHigh,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceLow,
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
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                            color: const Color(0xFF00120A), width: 2),
                      ),
                      child: const Icon(Icons.check,
                          size: 8, color: AppColors.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShiftHeroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Remaining time header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.timelapse,
                        size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SHIFT EXPIRATION',
                          style: AppText.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1)),
                      RichText(
                        text: TextSpan(
                          style: AppText.headlineSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600),
                          children: const [
                            TextSpan(text: '1h 46m '),
                            TextSpan(
                              text: 'remaining',
                              style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.tertiary),
                    ),
                    const SizedBox(width: 4),
                    Text('Shift 01',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.tertiary)),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 18,
            color: AppColors.surfaceHighest,
            thickness: 1,
          ),
          // Notes area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_note,
                      size: 14, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text('HANDOVER NOTES',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2)),
                ],
              ),
              Text(
                '${_noteCtrl.text.length} / 500',
                style: AppText.labelSm
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Quick tag buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _tagChip('+ VIP Villa 2', AppColors.primary),
                const SizedBox(width: 6),
                _tagChip('! Urgent', AppColors.secondary),
                const SizedBox(width: 6),
                _tagChip('Pavilion Event', AppColors.onSurfaceVariant),
                const SizedBox(width: 6),
                _tagChip('Front Desk', AppColors.onSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Note textarea
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _noteCtrl,
                  onChanged: (_) => setState(() {}),
                  maxLines: 3,
                  style: AppText.bodySm,
                  decoration: InputDecoration(
                    hintText:
                        'Share shift updates or guest requests...',
                    hintStyle: AppText.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant
                            .withOpacity(0.4)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mic,
                              size: 18,
                              color: AppColors.onSurfaceVariant),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 28, minHeight: 28),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file,
                              size: 18,
                              color: AppColors.onSurfaceVariant),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 28, minHeight: 28),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.cloud_done,
                            size: 12, color: AppColors.tertiary),
                        const SizedBox(width: 4),
                        Text('Autosaved',
                            style: AppText.labelSm.copyWith(
                                color: AppColors.tertiary)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label, Color color) {
    return GestureDetector(
      onTap: () {
        _noteCtrl.text += ' [$label]';
        setState(() {});
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: AppText.labelSm.copyWith(color: color)),
      ),
    );
  }

  Widget _buildReferenceCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCNmmJ-4JO67XCBM-CvsCwh9YsYDaYW7N1WacURlb32gECalHaN5XeZfKX_7iti-u-B7TBMO6SCBwOa9EpnpX60lwR3y6OBnHSHC5Ae85pAWNQdhRp5Dml5_I27Pb2Ui6x6QPh8jpBJUnwLtOgY-lQfAGi5C3As6V_nuv21QHKsTFnHR-Z2dAosJg-ZYvWpltG-Ux5gsYLRrebGYgkZJpOAQUEqTqnPQzoHMg8guSnr536vrraAmw2RjMyxj7x_NHYdX_I',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) =>
                  Container(color: AppColors.surfaceHighest),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shift Protocol Sync',
                    style: AppText.labelMd.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600)),
                Text(
                    'Duty guidelines verified with Manager Leo',
                    style: AppText.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.verified,
              size: 20, color: AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildPendingTasks() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('PENDING TASKS',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$_pendingCount pending',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              Text('Priority Order',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 10),
          // Task rows
          ...List.generate(_tasks.length, (i) {
            final t = _tasks[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(
                          () => _tasks[i] = _Task(t.label, !t.done)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: t.done
                              ? AppColors.primary
                              : AppColors.surfaceHighest,
                        ),
                        child: t.done
                            ? const Icon(Icons.check,
                                size: 12,
                                color: AppColors.onPrimary)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(t.label,
                          style: AppText.bodySm.copyWith(
                            color: t.done
                                ? AppColors.onSurfaceVariant
                                    .withOpacity(0.5)
                                : AppColors.onSurface,
                            decoration: t.done
                                ? TextDecoration.lineThrough
                                : null,
                          )),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _tasks.removeAt(i)),
                      child: const Icon(Icons.close,
                          size: 16,
                          color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Add task row
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _addTask,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.add,
                        size: 16, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _newTaskCtrl,
                    style: AppText.bodySm,
                    onSubmitted: (_) => _addTask(),
                    decoration: InputDecoration(
                      hintText: 'Add an upcoming task...',
                      hintStyle: AppText.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant
                              .withOpacity(0.4)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
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

  Widget _buildSubmitSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: _submitted
                  ? null
                  : const LinearGradient(
                      colors: [
                        Color(0xFFEE9800),
                        AppColors.secondary,
                        AppColors.secondaryFixed,
                      ],
                    ),
              color: _submitted ? AppColors.primaryContainer : null,
              borderRadius: BorderRadius.circular(14),
              boxShadow: _submitted
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ElevatedButton.icon(
              onPressed: _submitting || _submitted
                  ? null
                  : _submitHandover,
              icon: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Color(0xFF2A1700), strokeWidth: 2),
                    )
                  : Icon(
                      _submitted ? Icons.verified : Icons.arrow_forward,
                      size: 20,
                    ),
              label: Text(
                _submitting
                    ? 'Transmitting Handover...'
                    : _submitted
                        ? 'Handover Complete!'
                        : 'Submit Shift Handover',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: _submitted
                    ? AppColors.onPrimary
                    : const Color(0xFF2A1700),
                disabledForegroundColor: _submitted
                    ? AppColors.onPrimary.withOpacity(0.8)
                    : null,
                disabledBackgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: AppText.titleMd
                    .copyWith(fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: RichText(
            text: TextSpan(
              style: AppText.labelSm
                  .copyWith(color: AppColors.onSurfaceVariant),
              children: [
                const TextSpan(text: 'Incoming Staff: '),
                TextSpan(
                  text: 'Maria Elena Tan (Shift 02)',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Task {
  final String label;
  final bool done;
  const _Task(this.label, this.done);
}
