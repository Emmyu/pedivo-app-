import 'package:pedivo_activity_verification/models/index.dart';

/// Service responsible for verifying activity sessions based on defined rules
class VerificationService {
  // Verification rules configuration
  static const double minDistanceKm = 0.5;
  static const int minDurationMinutes = 5;
  static const double minAverageSpeedKmh = 3.0;
  static const double maxAverageSpeedKmh = 8.0;
  static const int minStepCount = 50;

  /// Verify an activity session based on predefined rules
  /// 
  /// Rules:
  /// 1. Distance must be at least 0.5 km
  /// 2. Duration must be at least 5 minutes
  /// 3. Average speed must be between 3-8 km/h (realistic walking pace)
  /// 4. Step count must be at least 50 (basic sanity check)
  /// 5. Route must have valid coordinates
  /// 
  /// Returns: Updated session with verification status and reason if rejected
  ActivitySession verify(ActivitySession session) {
    // Check if end time is set (session is completed)
    if (session.endTime == null) {
      return session.copyWith(
        verificationStatus: VerificationStatus.pending,
      );
    }

    // Rule 1: Check distance
    if (session.distanceKm < minDistanceKm) {
      return session.copyWith(
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Distance too short (minimum ${minDistanceKm} km)',
      );
    }

    // Rule 2: Check duration
    if (session.durationMinutes < minDurationMinutes) {
      return session.copyWith(
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Duration too short (minimum $minDurationMinutes minutes)',
      );
    }

    // Rule 3: Check average speed
    final avgSpeed = session.averageSpeedKmh;
    if (avgSpeed < minAverageSpeedKmh || avgSpeed > maxAverageSpeedKmh) {
      return session.copyWith(
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Invalid average speed ($avgSpeed km/h). Expected 3-8 km/h',
      );
    }

    // Rule 4: Check step count
    if (session.stepCount < minStepCount) {
      return session.copyWith(
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Insufficient step count (minimum $minStepCount steps)',
      );
    }

    // Rule 5: Validate route has coordinates
    if (session.route.isEmpty) {
      return session.copyWith(
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Invalid route data',
      );
    }

    // All checks passed
    return session.copyWith(
      verificationStatus: VerificationStatus.verified,
    );
  }

  /// Get verification rules as displayable text
  String getVerificationRules() {
    return '''
Verification Rules:
• Minimum distance: $minDistanceKm km
• Minimum duration: $minDurationMinutes minutes
• Average speed: $minAverageSpeedKmh - $maxAverageSpeedKmh km/h
• Minimum steps: $minStepCount
• Valid GPS coordinates required
    '''.trim();
  }
}
