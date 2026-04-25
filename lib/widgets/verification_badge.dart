import 'package:flutter/material.dart';
import 'package:pedivo_activity_verification/constants/app_theme.dart';
import 'package:pedivo_activity_verification/models/index.dart';

/// Badge widget to display verification status with color coding
class VerificationBadge extends StatelessWidget {
  final VerificationStatus status;
  final bool large;

  const VerificationBadge({
    Key? key,
    required this.status,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayName = status.displayName;
    final color = AppColors.getStatusColor(displayName);
    final lightColor = AppColors.getStatusLightColor(displayName);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? AppSpacing.md : AppSpacing.sm,
        vertical: large ? AppSpacing.sm : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: lightColor,
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Text(
        displayName,
        style: large ? AppTextStyles.label : AppTextStyles.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Icon widget to display status icon
class VerificationStatusIcon extends StatelessWidget {
  final VerificationStatus status;
  final double size;

  const VerificationStatusIcon({
    Key? key,
    required this.status,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (status) {
      case VerificationStatus.verified:
        icon = Icons.check_circle;
        color = AppColors.verifiedGreen;
        break;
      case VerificationStatus.pending:
        icon = Icons.schedule;
        color = AppColors.pendingOrange;
        break;
      case VerificationStatus.rejected:
        icon = Icons.cancel;
        color = AppColors.rejectedRed;
        break;
    }

    return Icon(icon, color: color, size: size);
  }
}
