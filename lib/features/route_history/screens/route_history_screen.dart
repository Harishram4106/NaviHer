import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../providers/route_history_provider.dart';

class RouteHistoryScreen extends ConsumerWidget {
  final VoidCallback onBack;

  const RouteHistoryScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(routeHistoryProvider);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPad + 12),
          // ── App bar ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
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
                const SizedBox(width: 16),
                Text(
                  'Route History',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: historyAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              ),
              error: (error, stack) => Center(
                child: Text('Failed to load history.', style: TextStyle(color: AppColors.danger)),
              ),
              data: (routes) {
                if (routes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          'No past routes found',
                          style: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: routes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final route = routes[index];
                    final dateStr = route.createdAt != null 
                        ? DateFormat('MMM d, yyyy • h:mm a').format(route.createdAt!)
                        : 'Unknown Date';
                        
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                route.name,
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: route.type == 'NaviHer Safe' 
                                      ? AppColors.primaryPink.withValues(alpha: 0.15) 
                                      : AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(AppRadius.small),
                                  border: Border.all(
                                    color: route.type == 'NaviHer Safe' 
                                        ? AppColors.primaryPink.withValues(alpha: 0.5) 
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  route.type,
                                  style: GoogleFonts.inter(
                                    fontSize: 10, 
                                    fontWeight: FontWeight.w600, 
                                    color: route.type == 'NaviHer Safe' ? AppColors.primaryPink : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dateStr,
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.schedule_rounded, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('${route.durationMinutes} min', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(width: 16),
                              Icon(Icons.route_rounded, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('${route.distanceKm} km', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                              const Spacer(),
                              Icon(Icons.shield_rounded, size: 14, color: AppColors.primaryPink),
                              const SizedBox(width: 4),
                              Text('Score: ${route.safetyScore}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryPink, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
