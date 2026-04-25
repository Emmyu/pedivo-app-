import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedivo_activity_verification/constants/app_theme.dart';
import 'package:pedivo_activity_verification/models/index.dart';
import 'package:pedivo_activity_verification/widgets/index.dart';

/// Detailed view for a single activity session
class SessionDetailScreen extends StatelessWidget {
  final ActivitySession session;

  const SessionDetailScreen({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with status
            _HeroSection(session: session),

            // Main content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map
                  _MapSection(session: session),
                  const SizedBox(height: AppSpacing.lg),

                  // Metrics
                  _MetricsSection(session: session),
                  const SizedBox(height: AppSpacing.lg),

                  // Verification Info
                  _VerificationSection(session: session),
                  const SizedBox(height: AppSpacing.lg),

                  // Route Details
                  _RouteDetailsSection(session: session),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hero section showing main session info
class _HeroSection extends StatelessWidget {
  final ActivitySession session;

  const _HeroSection({required this.session});

  String _formatTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Walking Session',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _formatTime(session.startTime),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              VerificationBadge(
                status: session.verificationStatus,
                large: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _HeroMetric(
                label: 'Distance',
                value: '${session.distanceKm.toStringAsFixed(2)} km',
              ),
              _HeroMetric(
                label: 'Duration',
                value:
                    '${session.durationMinutes} min', // Let's use a simpler format
              ),
              _HeroMetric(
                label: 'Steps',
                value: '${session.stepCount}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper widget for hero metrics
class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

/// Map section
class _MapSection extends StatelessWidget {
  final ActivitySession session;

  const _MapSection({required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Route Visualization',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: AppSpacing.md),
        MapPlaceholder(
          route: session.route,
          sessionId: session.id,
        ),
      ],
    );
  }
}

/// Detailed metrics section
class _MetricsSection extends StatelessWidget {
  final ActivitySession session;

  const _MetricsSection({required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Metrics',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: AppSpacing.md),
        _MetricRow(
          label: 'Average Speed',
          value: '${session.averageSpeedKmh.toStringAsFixed(2)} km/h',
          icon: Icons.speed,
        ),
        _MetricRow(
          label: 'Calories Burned (est.)',
          value: '${(session.stepCount * 0.04).toStringAsFixed(0)} kcal',
          icon: Icons.local_fire_department,
        ),
        _MetricRow(
          label: 'Steps per Minute',
          value: session.durationMinutes > 0
              ? '${(session.stepCount / session.durationMinutes).toStringAsFixed(1)} steps/min'
              : 'N/A',
          icon: Icons.trending_up,
        ),
      ],
    );
  }
}

/// Single metric row
class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodySmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: AppTextStyles.subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Verification section
class _VerificationSection extends StatelessWidget {
  final ActivitySession session;

  const _VerificationSection({required this.session});

  String _getVerificationDescription() {
    switch (session.verificationStatus) {
      case VerificationStatus.verified:
        return 'This session has passed all verification checks and is authentic.';
      case VerificationStatus.pending:
        return 'This session is pending verification. Our system is analyzing the data.';
      case VerificationStatus.rejected:
        return 'This session did not pass verification checks. See reason below.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightColor = AppColors.getStatusLightColor(session.verificationStatus.displayName);
    final color = AppColors.getStatusColor(session.verificationStatus.displayName);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VerificationStatusIcon(
                status: session.verificationStatus,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Status',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      session.verificationStatus.displayName,
                      style: AppTextStyles.subtitle.copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _getVerificationDescription(),
            style: AppTextStyles.bodySmall,
          ),
          if (session.rejectionReason != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rejection Reason:',
                    style: AppTextStyles.label.copyWith(color: color),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    session.rejectionReason!,
                    style: AppTextStyles.bodySmall.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Route details section showing GPS coordinates
class _RouteDetailsSection extends StatelessWidget {
  final ActivitySession session;

  const _RouteDetailsSection({required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Route Details',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waypoints: ${session.route.length}',
                style: AppTextStyles.label,
              ),
              const SizedBox(height: AppSpacing.md),
              if (session.route.isNotEmpty) ...[
                Text(
                  'Start Point',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Lat: ${session.route.first[0].toStringAsFixed(6)}, '
                  'Lng: ${session.route.first[1].toStringAsFixed(6)}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'End Point',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Lat: ${session.route.last[0].toStringAsFixed(6)}, '
                  'Lng: ${session.route.last[1].toStringAsFixed(6)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
