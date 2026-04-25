import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedivo_activity_verification/constants/app_theme.dart';
import 'package:pedivo_activity_verification/models/index.dart';
import 'package:pedivo_activity_verification/providers/activity_provider.dart';
import 'package:pedivo_activity_verification/screens/session_detail_screen.dart';
import 'package:pedivo_activity_verification/services/index.dart';
import 'package:pedivo_activity_verification/widgets/index.dart';

/// Main activity feed screen showing all walking sessions
class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Consumer<ActivityNotifier>(
        builder: (context, activityNotifier, _) {
          return _buildContent(context, activityNotifier);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ActivityNotifier notifier) {
    // Error state
    if (notifier.error != null) {
      return _ErrorWidget(
        error: notifier.error!,
        onRetry: () => notifier.refresh(),
      );
    }

    // Loading state (initial load)
    if (notifier.isLoading && notifier.activities.isEmpty) {
      return const _LoadingWidget();
    }

    // Empty state
    if (notifier.activities.isEmpty) {
      return const _EmptyWidget();
    }

    // Loaded state with list
    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      color: AppColors.primaryColor,
      backgroundColor: AppColors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          // Header with stats
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: _StatsCard(activities: notifier.activities),
          ),
          const SizedBox(height: AppSpacing.md),

          // Sessions list
          ...notifier.activities.map((session) {
            return SessionListItem(
              session: session,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SessionDetailScreen(session: session),
                  ),
                );
              },
            );
          }).toList(),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

/// Widget displaying activity statistics
class _StatsCard extends StatelessWidget {
  final List<ActivitySession> activities;

  const _StatsCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    final verified = activities
        .where((a) => a.verificationStatus == VerificationStatus.verified)
        .length;
    final pending = activities
        .where((a) => a.verificationStatus == VerificationStatus.pending)
        .length;
    final rejected = activities
        .where((a) => a.verificationStatus == VerificationStatus.rejected)
        .length;
    final totalDistance =
        activities.fold<double>(0, (sum, a) => sum + a.distanceKm);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Overview',
            style: AppTextStyles.heading3.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Verified',
                value: verified.toString(),
                color: AppColors.verifiedGreen,
              ),
              _StatItem(
                label: 'Pending',
                value: pending.toString(),
                color: AppColors.pendingOrange,
              ),
              _StatItem(
                label: 'Rejected',
                value: rejected.toString(),
                color: AppColors.rejectedRed,
              ),
              _StatItem(
                label: 'Total km',
                value: totalDistance.toStringAsFixed(1),
                color: AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper widget for individual stat items
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
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

/// Loading state widget
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryColor),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Loading your activities...',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Empty state widget
class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_walk,
            size: 64,
            color: AppColors.lightText,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No activities yet',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.mediumText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start a walking session to see it here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error state widget
class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Something went wrong',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              error,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
