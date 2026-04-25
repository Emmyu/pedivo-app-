import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedivo_activity_verification/constants/app_theme.dart';
import 'package:pedivo_activity_verification/models/index.dart';
import 'package:pedivo_activity_verification/widgets/verification_badge.dart';

void main() {
  group('VerificationBadge Widget Tests', () {
    testWidgets('Should display verified status badge', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationBadge(
              status: VerificationStatus.verified,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Verified'), findsOneWidget);
      expect(find.byType(VerificationBadge), findsOneWidget);
    });

    testWidgets('Should display pending status badge', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationBadge(
              status: VerificationStatus.pending,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('Should display rejected status badge', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationBadge(
              status: VerificationStatus.rejected,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Rejected'), findsOneWidget);
    });

    testWidgets('Should display large badge with large=true',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationBadge(
              status: VerificationStatus.verified,
              large: true,
            ),
          ),
        ),
      );

      // Act & Assert
      final container = find.byType(Container).first;
      expect(container, findsOneWidget);
    });
  });

  group('VerificationStatusIcon Widget Tests', () {
    testWidgets('Should display checkmark icon for verified status',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationStatusIcon(
              status: VerificationStatus.verified,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Should display schedule icon for pending status',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationStatusIcon(
              status: VerificationStatus.pending,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('Should display cancel icon for rejected status',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationStatusIcon(
              status: VerificationStatus.rejected,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Should display with custom size', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerificationStatusIcon(
              status: VerificationStatus.verified,
              size: 32,
            ),
          ),
        ),
      );

      // Assert
      final icon = find.byType(Icon);
      expect(icon, findsOneWidget);
    });
  });

  group('AppColors Tests', () {
    test('Should return green color for verified status', () {
      // Act
      final color = AppColors.getStatusColor('verified');

      // Assert
      expect(color, equals(AppColors.verifiedGreen));
    });

    test('Should return orange color for pending status', () {
      // Act
      final color = AppColors.getStatusColor('pending');

      // Assert
      expect(color, equals(AppColors.pendingOrange));
    });

    test('Should return red color for rejected status', () {
      // Act
      final color = AppColors.getStatusColor('rejected');

      // Assert
      expect(color, equals(AppColors.rejectedRed));
    });

    test('Should return light colors for status backgrounds', () {
      // Act
      final lightGreen = AppColors.getStatusLightColor('verified');
      final lightOrange = AppColors.getStatusLightColor('pending');
      final lightRed = AppColors.getStatusLightColor('rejected');

      // Assert
      expect(lightGreen, equals(AppColors.verifiedLightGreen));
      expect(lightOrange, equals(AppColors.pendingLightOrange));
      expect(lightRed, equals(AppColors.rejectedLightRed));
    });
  });

  group('ActivitySession Model Tests', () {
    test('Should calculate duration correctly', () {
      // Arrange
      const session = ActivitySession(
        id: 'test_001',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 45),
        distanceKm: 2.0,
        stepCount: 2800,
        route: [[37.7749, -122.4194]],
        verificationStatus: VerificationStatus.verified,
      );

      // Assert
      expect(session.durationMinutes, equals(45));
    });

    test('Should calculate average speed correctly', () {
      // Arrange
      const session = ActivitySession(
        id: 'test_001',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 11, 0), // 1 hour
        distanceKm: 5.0, // 5 km in 1 hour = 5 km/h
        stepCount: 3000,
        route: [[37.7749, -122.4194]],
        verificationStatus: VerificationStatus.verified,
      );

      // Act
      final avgSpeed = session.averageSpeedKmh;

      // Assert
      expect(avgSpeed, closeTo(5.0, 0.01));
    });
  });
}
