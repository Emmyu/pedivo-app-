import 'package:flutter_test/flutter_test.dart';
import 'package:pedivo_activity_verification/models/index.dart';
import 'package:pedivo_activity_verification/services/index.dart';

void main() {
  group('VerificationService Tests', () {
    late VerificationService verificationService;

    setUp(() {
      verificationService = VerificationService();
    });

    test('Should verify a valid session', () {
      // Arrange
      final now = DateTime.now();
      final validSession = ActivitySession(
        id: 'test_001',
        startTime: now.subtract(const Duration(minutes: 30)),
        endTime: now,
        distanceKm: 2.0,
        stepCount: 2800,
        route: [
          [37.7749, -122.4194],
          [37.7755, -122.4185],
          [37.7760, -122.4175],
        ],
        verificationStatus: VerificationStatus.pending,
      );

      // Act
      final result = verificationService.verify(validSession);

      // Assert
      expect(result.verificationStatus, equals(VerificationStatus.verified));
      expect(result.rejectionReason, isNull);
    });

    test('Should reject session with distance too short', () {
      // Arrange
      final now = DateTime.now();
      final shortDistanceSession = ActivitySession(
        id: 'test_002',
        startTime: now.subtract(const Duration(minutes: 10)),
        endTime: now,
        distanceKm: 0.2, // Less than 0.5 km
        stepCount: 500,
        route: [[37.7749, -122.4194]],
        verificationStatus: VerificationStatus.pending,
      );

      // Act
      final result = verificationService.verify(shortDistanceSession);

      // Assert
      expect(result.verificationStatus, equals(VerificationStatus.rejected));
      expect(result.rejectionReason, contains('Distance too short'));
    });

    test('Should reject session with duration too short', () {
      // Arrange
      final now = DateTime.now();
      final shortDurationSession = ActivitySession(
        id: 'test_003',
        startTime: now.subtract(const Duration(minutes: 2)),
        endTime: now,
        distanceKm: 1.0,
        stepCount: 500,
        route: [
          [37.7749, -122.4194],
          [37.7755, -122.4185],
        ],
        verificationStatus: VerificationStatus.pending,
      );

      // Act
      final result = verificationService.verify(shortDurationSession);

      // Assert
      expect(result.verificationStatus, equals(VerificationStatus.rejected));
      expect(result.rejectionReason, contains('Duration too short'));
    });

    test('Should reject session with invalid average speed (too fast)', () {
      // Arrange
      final now = DateTime.now();
      const tooFastSession = ActivitySession(
        id: 'test_004',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 10), // 10 minutes
        distanceKm: 5.0, // 5 km in 10 minutes = 30 km/h (too fast!)
        stepCount: 1500,
        route: [
          [37.7749, -122.4194],
          [37.7750, -122.4185],
        ],
        verificationStatus: VerificationStatus.pending,
      );

      // Act
      final result = verificationService.verify(tooFastSession);

      // Assert
      expect(result.verificationStatus, equals(VerificationStatus.rejected));
      expect(result.rejectionReason, contains('Invalid average speed'));
    });

    test('Should reject session with insufficient step count', () {
      // Arrange
      final now = DateTime.now();
      final lowStepsSession = ActivitySession(
        id: 'test_005',
        startTime: now.subtract(const Duration(minutes: 30)),
        endTime: now,
        distanceKm: 1.5,
        stepCount: 20, // Less than 50
        route: [
          [37.7749, -122.4194],
          [37.7755, -122.4185],
        ],
        verificationStatus: VerificationStatus.pending,
      );

      // Act
      final result = verificationService.verify(lowStepsSession);

      // Assert
      expect(result.verificationStatus, equals(VerificationStatus.rejected));
      expect(result.rejectionReason, contains('Insufficient step count'));
    });

    test('Should return pending status for incomplete session', () {
      // Arrange
      final now = DateTime.now();
      const incompleteSession = ActivitySession(
        id: 'test_006',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: null, // No end time
        distanceKm: 2.0,
        stepCount: 2800,
        route: [[37.7749, -122.4194]],
        verificationStatus: VerificationStatus.pending,
      );

      // Act
      final result = verificationService.verify(incompleteSession);

      // Assert
      expect(result.verificationStatus, equals(VerificationStatus.pending));
    });

    test('Should provide verification rules', () {
      // Act
      final rules = verificationService.getVerificationRules();

      // Assert
      expect(rules, contains('Minimum distance'));
      expect(rules, contains('Minimum duration'));
      expect(rules, contains('Average speed'));
      expect(rules, contains('Minimum steps'));
    });
  });

  group('ActivitySession Tests', () {
    test('Should calculate duration correctly', () {
      // Arrange
      const session = ActivitySession(
        id: 'test_001',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 30),
        distanceKm: 1.5,
        stepCount: 2000,
        route: [[37.7749, -122.4194]],
        verificationStatus: VerificationStatus.verified,
      );

      // Assert
      expect(session.durationMinutes, equals(30));
    });

    test('Should calculate average speed correctly', () {
      // Arrange
      const session = ActivitySession(
        id: 'test_001',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 30), // 30 minutes = 0.5 hours
        distanceKm: 3.0,
        stepCount: 2000,
        route: [[37.7749, -122.4194]],
        verificationStatus: VerificationStatus.verified,
      );

      // Act
      final avgSpeed = session.averageSpeedKmh;

      // Assert
      expect(avgSpeed, closeTo(6.0, 0.01)); // 3 km / 0.5 hours = 6 km/h
    });

    test('Should serialize and deserialize correctly', () {
      // Arrange
      const session = ActivitySession(
        id: 'test_001',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 30),
        distanceKm: 2.5,
        stepCount: 3500,
        route: [[37.7749, -122.4194], [37.7750, -122.4185]],
        verificationStatus: VerificationStatus.verified,
      );

      // Act
      final json = session.toJson();
      final deserialized = ActivitySession.fromJson(json);

      // Assert
      expect(deserialized.id, equals(session.id));
      expect(deserialized.distanceKm, equals(session.distanceKm));
      expect(deserialized.stepCount, equals(session.stepCount));
      expect(deserialized.verificationStatus, equals(session.verificationStatus));
    });

    test('Should copy with modified fields', () {
      // Arrange
      const session = ActivitySession(
        id: 'test_001',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 30),
        distanceKm: 2.5,
        stepCount: 3500,
        route: [[37.7749, -122.4194]],
        verificationStatus: VerificationStatus.pending,
      );

      // Act
      final modified = session.copyWith(
        verificationStatus: VerificationStatus.verified,
      );

      // Assert
      expect(modified.verificationStatus, equals(VerificationStatus.verified));
      expect(modified.id, equals(session.id));
      expect(modified.distanceKm, equals(session.distanceKm));
    });
  });

  group('ActivityService Tests', () {
    late ActivityService activityService;

    setUp(() {
      activityService = ActivityService();
    });

    test('Should return mock activities', () {
      // Act
      final activities = activityService.getActivities();

      // Assert
      expect(activities, isNotEmpty);
      expect(activities.length, greaterThan(0));
    });

    test('Should get activity by ID', () {
      // Arrange
      final activities = activityService.getActivities();
      final firstId = activities.first.id;

      // Act
      final found = activityService.getActivityById(firstId);

      // Assert
      expect(found, isNotNull);
      expect(found!.id, equals(firstId));
    });

    test('Should return null for non-existent activity', () {
      // Act
      final found = activityService.getActivityById('non_existent_id');

      // Assert
      expect(found, isNull);
    });

    test('Should refresh activities', () async {
      // Act
      final activities = await activityService.refreshActivities();

      // Assert
      expect(activities, isNotEmpty);
    });

    test('Should verify all activities', () {
      // Arrange
      final activities = activityService.getActivities();

      // Act
      final verifiedActivities =
          activityService.verifyAllActivities(activities);

      // Assert
      expect(verifiedActivities, isNotEmpty);
      expect(verifiedActivities.length, equals(activities.length));
      for (final activity in verifiedActivities) {
        expect(
          activity.verificationStatus,
          isIn([
            VerificationStatus.verified,
            VerificationStatus.pending,
            VerificationStatus.rejected,
          ]),
        );
      }
    });
  });

  group('VerificationStatus Tests', () {
    test('Should have correct display names', () {
      expect(VerificationStatus.verified.displayName, equals('Verified'));
      expect(VerificationStatus.pending.displayName, equals('Pending'));
      expect(VerificationStatus.rejected.displayName, equals('Rejected'));
    });

    test('Should have correct color hex values', () {
      expect(VerificationStatus.verified.colorHex, equals('#4CAF50'));
      expect(VerificationStatus.pending.colorHex, equals('#FF9800'));
      expect(VerificationStatus.rejected.colorHex, equals('#F44336'));
    });
  });
}
