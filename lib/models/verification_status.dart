/// Enum representing the verification status of an activity session
enum VerificationStatus {
  verified,
  pending,
  rejected,
}

extension VerificationStatusExtension on VerificationStatus {
  /// Get user-friendly string representation
  String get displayName {
    switch (this) {
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.pending:
        return 'Pending';
      case VerificationStatus.rejected:
        return 'Rejected';
    }
  }

  /// Get color representation for the status
  String get colorHex {
    switch (this) {
      case VerificationStatus.verified:
        return '#4CAF50'; // Green
      case VerificationStatus.pending:
        return '#FF9800'; // Orange
      case VerificationStatus.rejected:
        return '#F44336'; // Red
    }
  }
}
