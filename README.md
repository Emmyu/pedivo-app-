# Pedivo Activity Verification Dashboard

A Flutter mobile app that demonstrates location data handling, UI responsiveness, and state management through an activity verification dashboard. The app displays walking sessions and verifies them based on realistic criteria.

## App Screenshots

<p align="center">
  <img src="assets/screen%20-1.png" width="19%" alt="Activity feed screen" />
  <img src="assets/screen%202.png" width="19%" alt="Session detail screen" />
  <img src="assets/screen%203.png" width="19%" alt="Verification state screen" />
  <img src="assets/screem%204.png" width="19%" alt="Additional app screen" />
  <img src="assets/screen%205.png" width="19%" alt="Additional app screen" />
</p>

## Project Overview

Pedivo verifies genuine physical activity by implementing a complete activity verification system that includes:

- **Activity Feed** - Display of recent walking sessions with mocked local data
- **Session Detail View** - Detailed view with route visualization and metrics
- **Verification Logic** - Algorithm-based session verification
- **State Management** - Pull-to-refresh with proper state handling
- **Clean Architecture** - Separation of concerns with Models, Services, and Providers

## Features

### Core Features

**Activity Feed Screen**
- List of recent walking sessions
- Session information: start time, duration, distance, steps, verification status
- Session statistics overview (verified/pending/rejected counts, total distance)
- Pull-to-refresh functionality
- Responsive and elegant UI

**Session Detail Screen**
- Complete session information with hero section
- Custom-rendered route visualization/map placeholder
- Detailed performance metrics (average speed, calories, steps/min)
- Verification status with reasoning
- Route coordinates display

**Verification System**
- Rules-based verification algorithm
- Verification criteria:
  - Minimum distance: 0.5 km
  - Minimum duration: 5 minutes
  - Average speed: 3-8 km/h (realistic walking pace)
  - Minimum steps: 50
  - Valid GPS coordinates required
- Three status levels: Verified, Pending, Rejected

**State Management**
- Provider pattern for state management
- Loading, error, and empty states
- Pull-to-refresh with loading indicators
- Graceful error handling

**UI/UX**
- Material Design 3 based theme
- Responsive layouts
- Smooth transitions and animations
- Clear visual status indicators with color coding
- Accessible and polished interface

### Bonus Features

**Testing**
- Comprehensive unit tests for services and models
- Widget tests for UI components
- Test coverage for verification logic
- Test files:
  - `test/services_test.dart` - Service and model tests
  - `test/widget_test.dart` - Widget and color tests

**Mock Data**
- 6 pre-loaded mock sessions with realistic data
- Sessions from different locations worldwide
- Mix of verified, pending, and rejected statuses
- Realistic GPS coordinates and metrics

## Project Structure

```
lib/
├── main.dart                      # Application entry point
├── constants/
│   └── app_theme.dart            # Colors, text styles, spacing, durations
├── models/
│   ├── activity_session.dart      # Session model with JSON serialization
│   ├── verification_status.dart   # Verification status enum
│   └── index.dart                 # Models barrel export
├── services/
│   ├── activity_service.dart      # Activity data and business logic
│   ├── verification_service.dart  # Verification algorithm
│   └── index.dart                 # Services barrel export
├── providers/
│   └── activity_provider.dart     # State management with ChangeNotifier
├── screens/
│   ├── activity_feed_screen.dart  # Main activity list screen
│   ├── session_detail_screen.dart # Session detail view
│   └── index.dart                 # Screens barrel export
├── widgets/
│   ├── verification_badge.dart    # Status badge widget
│   ├── session_list_item.dart     # Activity session list item
│   ├── map_placeholder.dart       # Route visualization widget
│   └── index.dart                 # Widgets barrel export
└── test/
    ├── services_test.dart         # Service and model unit tests
    └── widget_test.dart           # Widget tests
```

## Technical Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **UI**: Material Design 3
- **Testing**: Flutter Test
- **Date Handling**: intl

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0         # State management
  intl: ^0.19.0           # Internationalization and date formatting
  shared_preferences: ^2.0.0  # Local storage (future use)
  http: ^1.1.0            # HTTP client (future backend integration)

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0   # Linting
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart (3.0 or higher)
- Android Studio or Xcode (for emulator/device)

### Installation

1. **Clone or extract the project**
   ```bash
   cd pedivo_test_app
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services_test.dart
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

## Screens

### 1. Activity Feed Screen
The main screen showing a list of all walking sessions with:
- Activity statistics overview
- Session cards with key metrics
- Pull-to-refresh functionality
- Navigation to detail screens

### 2. Session Detail Screen
Detailed view of a single session with:
- Hero section with main metrics
- Route visualization with custom painter
- Performance metrics breakdown
- Verification status and reasoning
- Route coordinates

## Verification Algorithm

The verification system checks sessions against realistic walking criteria:

```dart
// Verification Process
1. Check if session is completed (has end time)
2. Validate distance (≥ 0.5 km)
3. Validate duration (≥ 5 minutes)
4. Calculate and validate average speed (3-8 km/h)
5. Validate step count (≥ 50 steps)
6. Verify GPS coordinates exist

// Result States
- Verified: Passes all checks
- Pending: Incomplete session or awaiting verification
- Rejected: Failed one or more checks (with reason)
```

## Design System

The app uses a consistent design system defined in `app_theme.dart`:

### Colors
- **Primary**: Blue (#2196F3)
- **Status**: 
  - Verified: Green (#4CAF50)
  - Pending: Orange (#FF9800)
  - Rejected: Red (#F44336)

### Typography
- **Heading1**: 28px, Bold
- **Heading2**: 24px, Bold
- **Heading3**: 20px, Bold
- **Body**: 14-16px
- **Caption**: 11-12px

### Spacing
- **XS**: 4px
- **SM**: 8px
- **MD**: 16px
- **LG**: 24px
- **XL**: 32px

## Test Coverage

The project includes comprehensive tests:

### Service Tests (`test/services_test.dart`)
- Verification service: Valid/invalid sessions
- Activity service: Mock data retrieval
- Model serialization/deserialization
- Duration and speed calculations

### Widget Tests (`test/widget_test.dart`)
- Verification badges display
- Status icons rendering
- Color system functionality
- Model calculations

### Running Tests
```bash
flutter test                    # Run all tests
flutter test test/services_test.dart
flutter test test/widget_test.dart
```

## State Management Flow

```
ActivityNotifier (ChangeNotifier)
├── List<ActivitySession> _activities
├── bool _isLoading
├── String? _error
├── Initialize activities on creation
├── refresh() - Pull-to-refresh
└── getActivityById(id) - Get single activity

ActivityFeedScreen
├── Consumes ActivityNotifier
├── Displays activity list
└── Routes to SessionDetailScreen

SessionDetailScreen
├── Receives ActivitySession
├── Displays detailed information
└── Shows verification status
```

## Usage Examples

### Displaying Activities
```dart
Consumer<ActivityNotifier>(
  builder: (context, notifier, _) {
    return ListView.builder(
      itemCount: notifier.activities.length,
      itemBuilder: (context, index) {
        return SessionListItem(
          session: notifier.activities[index],
          onTap: () => navigateToDetail(notifier.activities[index]),
        );
      },
    );
  },
)
```

### Pulling to Refresh
```dart
RefreshIndicator(
  onRefresh: () => context.read<ActivityNotifier>().refresh(),
  child: ActivityList(),
)
```

### Verifying a Session
```dart
final verificationService = VerificationService();
final verifiedSession = verificationService.verify(session);
print(verifiedSession.verificationStatus); // Verified/Pending/Rejected
```

## Future Enhancements

Possible improvements and extensions:

1. **Offline Support**
   - Cache sessions locally with SQLite/Hive
   - Sync when online
   - Conflict resolution

2. **Real-time Updates**
   - Location simulation for active sessions
   - Real-time step tracking
   - Live route display

3. **Advanced Features**
   - Push notifications
   - Social sharing
   - User authentication
   - Backend API integration
   - Analytics dashboard
   - Performance insights

4. **UI/UX Improvements**
   - Animations for transitions
   - Custom map integration (Google Maps/Mapbox)
   - Charts for metrics visualization
   - Dark mode support

5. **Testing Enhancements**
   - Integration tests
   - Performance tests
   - UI automation tests
   - E2E testing

## API Reference

### ActivityService
```dart
List<ActivitySession> getActivities()           // Get all activities
ActivitySession? getActivityById(String id)     // Get activity by ID
Future<List<ActivitySession>> refreshActivities() // Refresh from API
List<ActivitySession> verifyAllActivities(List<ActivitySession>) // Verify all
```

### VerificationService
```dart
ActivitySession verify(ActivitySession)  // Verify single session
String getVerificationRules()            // Get rules description
```

### ActivityNotifier
```dart
List<ActivitySession> get activities     // Get activities list
bool get isLoading                        // Loading state
String? get error                         // Error message
Future<void> refresh()                    // Refresh activities
ActivitySession? getActivityById(String)  // Get activity by ID
```

## Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run
```

### Tests failing
```bash
flutter test --verbose
```

### Hot reload issues
```bash
flutter clean
flutter run --no-fast-start
```

## Code Quality

The project follows best practices:
- Separation of concerns (Models/Services/Screens)
- SOLID principles
- Comprehensive documentation
- Clean naming conventions
- Type-safe code
- Error handling
- Unit and widget tests

## License

This project is provided as a demonstration app for Pedivo activity verification.

## Support

For questions or issues:
1. Check the test files for usage examples
2. Review inline code documentation
3. Examine the models and services for API reference

---

Built for activity verification.
