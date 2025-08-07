# Shift Management Feature

A comprehensive shift management system for the Flow 360 app with beautiful animations and micro-interactions.

## Features

### 🎯 Core Functionality
- **Start/End Shifts**: Easy one-tap shift management
- **Real-time Timer**: Live duration tracking with smooth animations
- **Shift History**: Complete history of all shifts with detailed information
- **Status Indicators**: Visual status indicators with pulse animations
- **Floating Action Button**: Quick access to shift actions

### 🎨 UI/UX Features
- **Micro-interactions**: Smooth animations for all user interactions
- **Responsive Design**: Adapts to different screen sizes
- **Modern UI**: Material Design 3 with custom styling
- **Loading States**: Beautiful loading animations
- **Error Handling**: User-friendly error messages with snackbars

## Architecture

### Backend Integration
The feature integrates with the Django backend API:

- **POST** `/shift/create/` - Start a new shift
- **PATCH** `/shift/{id}/update/` - End an existing shift
- **GET** `/shift/list/` - Get all shifts for the user
- **GET** `/shift/{id}/` - Get specific shift details

### Frontend Structure

```
lib/features/shift/
├── models/
│   └── shift_model.dart          # Data model with JSON serialization
├── repository/
│   └── shift_repository.dart     # API communication layer
├── controllers/
│   └── shift_controller.dart     # Business logic with GetX state management
├── presentation/
│   ├── screens/
│   │   ├── shift_management_screen.dart  # Main shift management UI
│   │   └── shift_demo_screen.dart        # Demo screen for testing
│   └── widgets/
│       ├── shift_fab.dart                # Floating action button
│       └── shift_status_indicator.dart   # Status indicator widget
└── test/
    └── shift_controller_test.dart        # Unit tests
```

## Components

### 1. ShiftController
- **Reactive State Management**: Uses GetX for reactive UI updates
- **Error Handling**: Comprehensive error handling with user feedback
- **Timer Logic**: Real-time duration calculation
- **API Integration**: Seamless backend communication

### 2. ShiftManagementScreen
- **Current Shift Card**: Shows active shift with gradient background
- **Action Buttons**: Start/End shift with loading states
- **Shift History**: Animated list of past shifts
- **Pull-to-Refresh**: Refresh data with pull gesture

### 3. ShiftFAB (Floating Action Button)
- **Dynamic Colors**: Changes color based on shift status
- **Confirmation Dialogs**: User-friendly confirmation before actions
- **Smooth Animations**: AnimatedSwitcher for smooth transitions

### 4. ShiftStatusIndicator
- **Pulse Animation**: Animated indicator for active shifts
- **Compact Design**: Perfect for dashboard integration
- **Real-time Updates**: Live timer updates

## Usage

### Basic Implementation

```dart
// In your main app or screen
import 'package:flow_360/features/shift/shift.dart';

// Initialize the controller
final shiftController = Get.put(ShiftController());

// Use the main screen
ShiftManagementScreen()

// Or use individual widgets
ShiftStatusIndicator()
ShiftFAB()
```

### Integration with Dashboard

```dart
// Add to your dashboard
Column(
  children: [
    ShiftStatusIndicator(),
    // Other dashboard widgets
  ],
)

// Add FAB to your main screen
Scaffold(
  body: YourMainContent(),
  floatingActionButton: ShiftFAB(),
)
```

## Animations & Micro-interactions

### 1. Container Animations
- **AnimatedContainer**: Smooth transitions for status changes
- **Gradient Transitions**: Dynamic gradient backgrounds
- **Scale Animations**: Pulse effects for active indicators

### 2. Button Interactions
- **Loading States**: Circular progress indicators
- **Color Transitions**: Smooth color changes
- **Elevation Changes**: Dynamic shadow effects

### 3. List Animations
- **Staggered Animations**: Sequential item animations
- **Slide Effects**: Smooth entry animations
- **Scale Effects**: Subtle scaling on interactions

### 4. Timer Animations
- **Real-time Updates**: Stream-based timer updates
- **Smooth Transitions**: Continuous duration updates
- **Visual Feedback**: Color-coded duration indicators

## API Endpoints

### Backend Requirements

The feature expects the following Django backend endpoints:

```python
# URLs (shifts/urls.py)
urlpatterns = [
    path("create/", CreateShiftView.as_view(), name="create-shift"),
    path("list/", ListShiftsView.as_view(), name="list-shifts"),
    path("<uuid:pk>/", RetrieveShiftView.as_view(), name="retrieve-shift"),
    path("<uuid:pk>/update/", UpdateShiftView.as_view(), name="update-shift"),
]
```

### Request/Response Format

**Start Shift:**
```json
POST /shift/create/
{
  "started_at": "2024-01-01T09:00:00Z"
}
```

**End Shift:**
```json
PATCH /shift/{id}/update/
{
  "ended_at": "2024-01-01T17:00:00Z",
  "is_active": false
}
```

**Shift Model:**
```json
{
  "id": "uuid",
  "started_at": "2024-01-01T09:00:00Z",
  "ended_at": "2024-01-01T17:00:00Z",
  "is_active": true,
  "created_at": "2024-01-01T09:00:00Z",
  "station": "station-uuid",
  "employee": 1
}
```

## Testing

Run the unit tests:

```bash
flutter test lib/features/shift/test/
```

## Dependencies

The feature uses the following packages:
- `get` - State management
- `dio` - HTTP client
- `intl` - Date formatting
- `json_annotation` - JSON serialization

## Future Enhancements

- [ ] Shift statistics and analytics
- [ ] Break time tracking
- [ ] Shift templates
- [ ] Offline support
- [ ] Push notifications for shift reminders
- [ ] Multi-language support
- [ ] Dark mode optimizations
