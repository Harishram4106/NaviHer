import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/glass_container.dart';
import '../providers/report_provider.dart';
import '../../demo/providers/demo_state_provider.dart';

class ReportIncidentScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const ReportIncidentScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  ConsumerState<ReportIncidentScreen> createState() =>
      _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends ConsumerState<ReportIncidentScreen> {
  int _activeTab = 0; // 0=Safety Risk, 1=Accident, 2=Harassment, 3=Other
  int _selectedCategory = 0; // index in the 6-grid
  bool _shareAnonymously = true;
  bool _showSignalReceived = false;
  bool _showIntelligenceUpdated = false;
  final _descriptionController = TextEditingController();

  final List<_IncidentCategory> _categories = const [
    _IncidentCategory(Icons.lightbulb_outline_rounded, 'Poor Lighting', AppColors.primaryPink),
    _IncidentCategory(Icons.visibility_off_outlined, 'Suspicious Activity', AppColors.textSecondary),
    _IncidentCategory(Icons.warning_amber_rounded, 'Unsafe Area', AppColors.textSecondary),
    _IncidentCategory(Icons.alt_route_rounded, 'Road Issue', AppColors.textSecondary),
    _IncidentCategory(Icons.fence_rounded, 'Obstruction', AppColors.textSecondary),
    _IncidentCategory(Icons.more_horiz_rounded, 'Other', AppColors.textSecondary),
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    final cat = _categories[_selectedCategory].label;
    final desc = _descriptionController.text;

    await ref.read(communityReportNotifierProvider.notifier).submitReport(
      category: cat.toLowerCase().replaceAll(' ', '_'),
      description: desc,
      isAnonymous: _shareAnonymously,
    );

    ref.read(demoStateProvider.notifier).submitCommunityReport();

    if (mounted) {
      setState(() => _showSignalReceived = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _showSignalReceived = false;
          _showIntelligenceUpdated = true;
        });
        await Future.delayed(const Duration(seconds: 2));
      }
      if (mounted) {
        widget.onSubmit();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;
    
    final submitState = ref.watch(communityReportNotifierProvider);
    final isSubmitting = submitState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: 92 + botPad,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topPad + 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report an Incident',
                          style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Help make NaviHer safer for everyone',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Type tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildTypeTab(0, Icons.shield_rounded, 'Safety Risk'),
                        const SizedBox(width: 6),
                        _buildTypeTab(1, Icons.directions_car_rounded, 'Accident'),
                        const SizedBox(width: 6),
                        _buildTypeTab(2, Icons.person_off_rounded, 'Harassment'),
                        const SizedBox(width: 6),
                        _buildTypeTab(3, Icons.more_horiz_rounded, 'Other'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Scrollable form content ───────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2x3 category grid
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.05,
                          children: List.generate(_categories.length, (i) {
                            final cat = _categories[i];
                            final isSelected = _selectedCategory == i;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategory = i),
                              child: GlassContainer.custom(
                                padding: EdgeInsets.zero,
                                backgroundColor: isSelected
                                    ? AppColors.primaryPink.withValues(alpha: 0.15)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(AppRadius.medium),
                                borderColor: isSelected ? AppColors.primaryPink : AppColors.border,
                                borderOpacity: isSelected ? 1.0 : 0.12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      cat.icon,
                                      color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cat.label,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.white : AppColors.textSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // Add Details label
                        Text(
                          'Add Details',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 12),

                        // Description text field
                        GlassContainer.neutral(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextField(
                                controller: _descriptionController,
                                maxLines: 4,
                                maxLength: 200,
                                style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Tell us what happened...',
                                  hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(14),
                                  counterText: '',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 14, bottom: 10),
                                child: ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _descriptionController,
                                  builder: (context, value, child) => Text(
                                    '${value.text.length}/200',
                                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Add Photos row
                        GlassContainer.neutral(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(AppRadius.small),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Icon(Icons.add_rounded, color: AppColors.textSecondary, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Add Photos (Optional)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                    Text('Photos help us verify and respond faster', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Location row
                        GlassContainer.neutral(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: AppColors.primaryPink, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Location', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                    Text('Current Location', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: Text('Change', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Share Anonymously toggle
                        GlassContainer.neutral(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceElevated,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Share Anonymously', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                    Text('Your identity will not be shown', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _shareAnonymously,
                                onChanged: (v) => setState(() => _shareAnonymously = v),
                                activeThumbColor: Colors.white,
                                activeTrackColor: AppColors.primaryPink,
                                inactiveThumbColor: AppColors.textMuted,
                                inactiveTrackColor: AppColors.surfaceElevated,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Submit button pinned to bottom ────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.0),
                    AppColors.background.withValues(alpha: 0.8),
                    AppColors.background,
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.2, 0.6, 1.0],
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 32, 20, botPad + 20),
              child: GestureDetector(
                onTap: isSubmitting ? null : _submitReport,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSubmitting ? AppColors.surfaceElevated : AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: isSubmitting ? [] : [
                      BoxShadow(
                        color: AppColors.primaryPink.withValues(alpha: 0.40),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSubmitting)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      else ...[
                        Text('Submit Report', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(width: 8),
                        const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_showSignalReceived)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: GlassContainer.custom(
                    padding: const EdgeInsets.all(32),
                    backgroundColor: AppColors.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    borderColor: AppColors.primaryPink,
                    borderOpacity: 0.5,
                    showShadow: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cell_tower_rounded, color: AppColors.primaryPink, size: 60),
                        ),
                        const SizedBox(height: 24),
                        Text('SIGNAL RECEIVED', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2)),
                        const SizedBox(height: 12),
                        Text('Thank you for making the\nNaviHer community safer.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_showIntelligenceUpdated)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: GlassContainer.custom(
                    padding: const EdgeInsets.all(32),
                    backgroundColor: AppColors.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    borderColor: AppColors.secondaryPurple,
                    borderOpacity: 0.5,
                    showShadow: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryPurple.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.map_rounded, color: AppColors.secondaryPurple, size: 60),
                        ),
                        const SizedBox(height: 24),
                        Text('SAFETY INTELLIGENCE\nUPDATED', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2)),
                        const SizedBox(height: 12),
                        Text('NaviHer map has been updated.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypeTab(int idx, IconData icon, String label) {
    final isSelected = _activeTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPink : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: isSelected ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncidentCategory {
  final IconData icon;
  final String label;
  final Color color;
  const _IncidentCategory(this.icon, this.label, this.color);
}
