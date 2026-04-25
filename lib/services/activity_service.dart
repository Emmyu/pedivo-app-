import 'package:pedivo_activity_verification/models/index.dart';
import 'package:pedivo_activity_verification/services/verification_service.dart';

/// Service responsible for managing activity sessions
/// 
/// In a real app, this would handle:
/// - Fetching data from backend API
/// - Local caching with shared_preferences
/// - Synchronization logic
/// 
/// For this demo, it provides mocked data
class ActivityService {
  final VerificationService _verificationService = VerificationService();

  /// Get all activity sessions
  /// Mock data - returns hardcoded sessions for demonstration
  List<ActivitySession> getActivities() {
    return _generateMockSessions();
  }

  /// Get a specific activity by ID
  ActivitySession? getActivityById(String id) {
    final activities = getActivities();
    try {
      return activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Refresh activities (simulates API call)
  /// In a real app, this would fetch from backend
  Future<List<ActivitySession>> refreshActivities() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    return _generateMockSessions();
  }

  /// Generate mock activity sessions with realistic data
  List<ActivitySession> _generateMockSessions() {
    final now = DateTime.now();

    return [
      // Session 1: Valid verified session
      ActivitySession(
        id: 'session_001',
        startTime: now.subtract(const Duration(days: 1, hours: 10)),
        endTime: now.subtract(const Duration(days: 1, hours: 9, minutes: 45)),
        distanceKm: 2.5,
        stepCount: 3200,
        route: [
          [37.7749, -122.4194], // SF
          [37.7755, -122.4185],
          [37.7760, -122.4175],
          [37.7765, -122.4165],
          [37.7770, -122.4155],
        ],
        verificationStatus: VerificationStatus.verified,
      ),
      // Session 2: Valid pending session (just created)
      ActivitySession(
        id: 'session_002',
        startTime: now.subtract(const Duration(hours: 2)),
        endTime: now.subtract(const Duration(minutes: 30)),
        distanceKm: 1.8,
        stepCount: 2450,
        route: [
          [40.7128, -74.0060], // NYC
          [40.7135, -74.0070],
          [40.7140, -74.0080],
          [40.7145, -74.0090],
        ],
        verificationStatus: VerificationStatus.pending,
      ),
      // Session 3: Rejected - too fast (suspicious)
      ActivitySession(
        id: 'session_003',
        startTime: now.subtract(const Duration(days: 2, hours: 14)),
        endTime: now.subtract(const Duration(days: 2, hours: 14, minutes: 10)),
        distanceKm: 5.2,
        stepCount: 1200,
        route: [
          [51.5074, -0.1278], // London
          [51.5100, -0.1250],
          [51.5125, -0.1220],
        ],
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Invalid average speed (31.2 km/h). Expected 3-8 km/h',
      ),
      // Session 4: Valid verified session
      ActivitySession(
        id: 'session_004',
        startTime: now.subtract(const Duration(days: 3, hours: 8)),
        endTime: now.subtract(const Duration(days: 3, hours: 7, minutes: 20)),
        distanceKm: 1.2,
        stepCount: 1680,
        route: [
          [48.8566, 2.3522], // Paris
          [48.8570, 2.3530],
          [48.8575, 2.3540],
        ],
        verificationStatus: VerificationStatus.verified,
      ),
      // Session 5: Rejected - too short distance
      ActivitySession(
        id: 'session_005',
        startTime: now.subtract(const Duration(days: 4, hours: 16)),
        endTime: now.subtract(const Duration(days: 4, hours: 16, minutes: 15)),
        distanceKm: 0.2,
        stepCount: 150,
        route: [
          [35.6762, 139.6503], // Tokyo
          [35.6765, 139.6510],
        ],
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Distance too short (minimum 0.5 km)',
      ),
      // Session 6: Valid verified session
      ActivitySession(
        id: 'session_006',
        startTime: now.subtract(const Duration(days: 5, hours: 11)),
        endTime: now.subtract(const Duration(days: 5, hours: 10, minutes: 30)),
        distanceKm: 3.1,
        stepCount: 4100,
        route: [
          [-33.8688, 151.2093], // Sydney
          [-33.8695, 151.2100],
          [-33.8702, 151.2107],
          [-33.8709, 151.2114],
          [-33.8716, 151.2121],
        ],
        verificationStatus: VerificationStatus.verified,
      ),
    ];
  }

  /// Verify all unverified activities
  /// This would typically be called periodically or on user request
  List<ActivitySession> verifyAllActivities(
    List<ActivitySession> activities,
  ) {
    return activities
        .map((activity) => _verificationService.verify(activity))
        .toList();
  }
}
