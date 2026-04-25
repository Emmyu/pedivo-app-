import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedivo_activity_verification/constants/app_theme.dart';
import 'package:pedivo_activity_verification/models/index.dart';
import 'package:pedivo_activity_verification/widgets/verification_badge.dart';

/// List item widget for displaying a single activity session in the feed
class SessionListItem extends StatelessWidget {
  final ActivitySession session;
  final VoidCallback onTap;

  const SessionListItem({
    Key? key,
    required this.session,
    required this.onTap,
  }) : super(key: key);

  String _formatTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: AppColors.divider, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Date and Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(session.startTime),
                          style: AppTextStyles.subtitle,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Session ID: ${session.id.replaceFirst('session_', '')}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  VerificationBadge(status: session.verificationStatus),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Activity Metrics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricCard(
                    icon: Icons.straighten,
                    label: 'Distance',
                    value: '${session.distanceKm.toStringAsFixed(2)} km',
                  ),
                  _MetricCard(
                    icon: Icons.timer,
                    label: 'Duration',
                    value: _formatDuration(session.durationMinutes),
                  ),
                  _MetricCard(
                    icon: Icons.directions_walk,
                    label: 'Steps',
                    value: '${session.stepCount}',
                  ),
                  _MetricCard(
                    icon: Icons.speed,
                    label: 'Avg Speed',
                    value: '${session.averageSpeedKmh.toStringAsFixed(1)} km/h',
                  ),
                ],
              ),

              // Rejection reason if applicable
              if (session.verificationStatus == VerificationStatus.rejected &&
                  session.rejectionReason != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.rejectedLightRed,
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info,
                          color: AppColors.rejectedRed,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            session.rejectionReason!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.rejectedRed,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Tap to view details hint
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tap to view details',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.lightText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper widget to display a single metric
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
