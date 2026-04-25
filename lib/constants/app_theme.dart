import 'package:flutter/material.dart';

/// App color scheme and theme colors
class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Status colors
  static const Color verifiedGreen = Color(0xFF4CAF50);
  static const Color verifiedLightGreen = Color(0xFFC8E6C9);
  static const Color pendingOrange = Color(0xFFFF9800);
  static const Color pendingLightOrange = Color(0xFFFFE0B2);
  static const Color rejectedRed = Color(0xFFF44336);
  static const Color rejectedLightRed = Color(0xFFFFCDD2);

  // Neutral colors
  static const Color darkText = Color(0xFF212121);
  static const Color mediumText = Color(0xFF757575);
  static const Color lightText = Color(0xFFBDBDBD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFE0E0E0);

  // Background colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Error and success
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF2E7D32);

  /// Get color for verification status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return verifiedGreen;
      case 'pending':
        return pendingOrange;
      case 'rejected':
        return rejectedRed;
      default:
        return mediumText;
    }
  }

  /// Get light background color for verification status
  static Color getStatusLightColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return verifiedLightGreen;
      case 'pending':
        return pendingLightOrange;
      case 'rejected':
        return rejectedLightRed;
      default:
        return lightGrey;
    }
  }
}

/// App text styles and typography
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkText,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.darkText,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.mediumText,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.lightText,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
  );
}

/// App spacing and sizing constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// App border radius constants
class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double circular = 9999.0;
}

/// Durations for animations
class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
