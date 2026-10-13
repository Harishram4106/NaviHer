import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../demo/providers/demo_state_provider.dart';

class SafetyPreferencesSheet extends ConsumerWidget {
  const SafetyPreferencesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demoState = ref.watch(demoStateProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Safety Preferences',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Notifications
          _buildSwitchRow(
            icon: Icons.notifications_active_rounded,
            title: 'Safety Alerts',
            subtitle: 'Receive real-time hazard warnings',
            value: demoState.notificationsEnabled,
            onChanged: (val) {
              ref.read(demoStateProvider.notifier).toggleNotifications(val);
            },
          ),
          const SizedBox(height: 16),
          
          // Routing Priority
          _buildSegmentedControl(
            title: 'Default Routing Priority',
            options: ['Safest', 'Fastest'],
            selectedIndex: demoState.safetyPriority,
            onChanged: (val) {
              ref.read(demoStateProvider.notifier).setSafetyPriority(val);
            },
          ),
          const SizedBox(height: 16),
          
          // Emergency Mode Auto-trigger (Demo)
          _buildSwitchRow(
            icon: Icons.flash_on_rounded,
            title: 'Shake to Emergency',
            subtitle: 'Trigger SOS by shaking phone',
            value: demoState.emergencyModeEnabled,
            onChanged: (val) {
              ref.read(demoStateProvider.notifier).toggleEmergencyMode(val);
            },
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Icon(icon, color: AppColors.primaryPink, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              const SizedBox(height: 2),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primaryPink,
          activeTrackColor: AppColors.primaryPink.withValues(alpha: 0.3),
          inactiveThumbColor: AppColors.textMuted,
          inactiveTrackColor: AppColors.surface,
        ),
      ],
    );
  }

  Widget _buildSegmentedControl({
    required String title,
    required List<String> options,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 12),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: List.generate(options.length, (index) {
              final isSelected = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.surfaceElevated : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: Center(
                      child: Text(
                        options[index],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.primaryPink : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
