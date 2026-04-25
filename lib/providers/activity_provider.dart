import 'package:flutter/material.dart';
import 'package:pedivo_activity_verification/models/index.dart';
import 'package:pedivo_activity_verification/services/index.dart';

/// State notifier for managing activities and loading states
class ActivityNotifier extends ChangeNotifier {
  final ActivityService _activityService;
  final VerificationService _verificationService;

  List<ActivitySession> _activities = [];
  bool _isLoading = false;
  String? _error;

  ActivityNotifier(this._activityService, this._verificationService) {
    _initialize();
  }

  // Getters
  List<ActivitySession> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize and load activities
  Future<void> _initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final activities = _activityService.getActivities();
      _activities = _activityService.verifyAllActivities(activities);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh activities (pull-to-refresh)
  Future<void> refresh() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final activities = await _activityService.refreshActivities();
      _activities = _activityService.verifyAllActivities(activities);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get a single activity by ID
  ActivitySession? getActivityById(String id) {
    try {
      return _activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }
}
