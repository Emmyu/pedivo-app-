import 'package:pedivo_activity_verification/models/verification_status.dart';

/// Model representing a walking activity session
class ActivitySession {
  /// Unique identifier for the session
  final String id;

  /// Session start time
  final DateTime startTime;

  /// Session end time (if completed)
  final DateTime? endTime;

  /// Distance walked in kilometers
  final double distanceKm;

  /// Number of steps taken
  final int stepCount;

  /// List of GPS coordinates [lat, lng] representing the route
  /// For mock purposes, this can be a simplified list
  final List<List<double>> route;

  /// Verification status
  final VerificationStatus verificationStatus;

  /// Reason for rejection (if applicable)
  final String? rejectionReason;

  ActivitySession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.distanceKm,
    required this.stepCount,
    required this.route,
    required this.verificationStatus,
    this.rejectionReason,
  });

  /// Get duration of the session in minutes
  int get durationMinutes {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }

  /// Get average speed in km/h
  double get averageSpeedKmh {
    if (durationMinutes == 0) return 0;
    return (distanceKm / durationMinutes) * 60;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'distanceKm': distanceKm,
        'stepCount': stepCount,
        'route': route,
        'verificationStatus': verificationStatus.name,
        'rejectionReason': rejectionReason,
      };

  /// Create from JSON
  factory ActivitySession.fromJson(Map<String, dynamic> json) {
    return ActivitySession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      stepCount: json['stepCount'] as int,
      route: List<List<double>>.from(
        (json['route'] as List).map(
          (item) => List<double>.from((item as List).cast<double>()),
        ),
      ),
      verificationStatus: VerificationStatus.values.firstWhere(
        (status) => status.name == (json['verificationStatus'] as String),
      ),
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  /// Create a copy with modified fields
  ActivitySession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    double? distanceKm,
    int? stepCount,
    List<List<double>>? route,
    VerificationStatus? verificationStatus,
    String? rejectionReason,
  }) {
    return ActivitySession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distanceKm: distanceKm ?? this.distanceKm,
      stepCount: stepCount ?? this.stepCount,
      route: route ?? this.route,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
