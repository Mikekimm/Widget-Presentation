# We The Artists - Account Screen Implementation

## Overview
This implementation provides a complete, production-ready Account Screen for the "We The Artists" mobile application following Flutter clean architecture principles and the design specifications from your project proposal.

## 📁 Project Structure

```
lib/
├── core/
│   └── constants/
│       ├── app_colors.dart         # Color palette (White bg, Black text, Blue accent)
│       ├── app_text_styles.dart    # Typography (Inika headings, Jost body)
│       ├── app_dimensions.dart     # Spacing and dimensions
│       └── app_theme.dart          # Complete app theme
├── domain/
│   └── models/
│       ├── user_model.dart         # User entity with JSON serialization
│       └── post_model.dart         # Post entity with JSON serialization
├── presentation/
│   ├── screens/
│   │   └── account_screen.dart     # Main account screen
│   └── widgets/
│       └── profile/
│           ├── profile_header.dart # Avatar, name, username, discipline
│           ├── stats_card.dart     # Followers/Following/Posts stats
│           ├── bio_section.dart    # Bio with expandable text
│           └── posts_grid.dart     # 3-column grid of user posts
└── main.dart                       # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: Blue (#2196F3) - Accent color for buttons and highlights
- **Background**: White (#FFFFFF) - Clean canvas
- **Text**: Black (#000000) - High contrast, accessible
- **Secondary Text**: Gray variations for hierarchy

### Typography
- **Headings**: Inika font family (bold, 32-20px)
- **Body Text**: Jost font family (regular, 16-12px)
- **Buttons**: Jost font family (semi-bold, 16-14px)

### Spacing
- XS: 4px, S: 8px, M: 16px, L: 24px, XL: 32px
- Touch targets: Minimum 48x48px for accessibility

## ✨ Features Implemented

### Account Screen (`account_screen.dart`)
- ✅ Profile header with avatar (120px), name, username, and discipline badge
- ✅ Edit Profile button with proper touch target
- ✅ Stats card showing Posts, Followers, and Following counts
- ✅ Expandable bio section with "Read more/less" functionality
- ✅ Interest tags displayed as chips
- ✅ 3-column grid layout for posts (matching Instagram/social media patterns)
- ✅ Post media type indicators (video, audio, multiple images)
- ✅ Pull-to-refresh functionality
- ✅ Settings menu accessed via bottom sheet
- ✅ Menu options: Settings, Saved Posts, Wellness Resources, Help & Support, Logout
- ✅ Empty state for users with no posts

### Reusable Widgets

#### `ProfileHeader`
- Circular avatar with fallback icon
- Name display (H2 heading)
- Username with @ prefix
- Discipline badge with blue accent
- Optional Edit Profile button

#### `StatsCard`
- Horizontal layout with three stat items
- Formatted counts (1.2K, 1.5M format)
- Vertical dividers between items
- Tappable Followers/Following sections
- Rounded container with border

#### `BioSection`
- Expandable text with 3-line limit
- "Read more/less" toggle
- Interest tags as chips
- Clean typography hierarchy

#### `PostsGrid`
- 3-column grid with 2px spacing
- Image loading with placeholder
- Media type indicators (video, audio, multi-image)
- Error handling for failed image loads
- Empty state with icon and message
- Tap to view post detail

## 🔧 How to Run

1. **Ensure you have Flutter installed**:
   ```bash
   flutter doctor
   ```

2. **Get dependencies** (if needed):
   ```bash
   cd /Users/michaelkimani/Desktop/artists_account
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

4. **Test on different devices**:
   - Small screens (≤ 5.5")
   - Large screens (≥ 6.7")
   - Rotate to landscape to verify no pixel overflow

## 🎯 Mock Data

Currently using mock data for demonstration:
- **User**: Jean Claude Uwimana (@jeanvisuals)
- **Discipline**: Visual Arts
- **Stats**: 1,245 followers, 387 following, 42 posts
- **Posts**: 12 sample posts with random images from picsum.photos

## 🔄 Next Steps (Integration with Firebase)

### 1. Add Firebase Dependencies
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
```

### 2. Create Firestore Collections

**users** collection:
```json
{
  "id": "userId",
  "name": "Jean Claude",
  "username": "jeanvisuals",
  "bio": "Artist bio...",
  "profileImageUrl": "gs://...",
  "discipline": "Visual Arts",
  "followersCount": 1245,
  "followingCount": 387,
  "postsCount": 42,
  "createdAt": "2024-01-15T00:00:00Z",
  "interests": ["Digital Art", "Photography"]
}
```

**posts** collection:
```json
{
  "id": "postId",
  "userId": "userId",
  "caption": "My artwork",
  "mediaUrls": ["gs://..."],
  "mediaType": "image",
  "tags": ["art", "digital"],
  "likesCount": 45,
  "commentsCount": 12,
  "createdAt": "2024-01-15T00:00:00Z",
  "needsFeedback": false
}
```

### 3. Implement State Management (BLoC/Cubit)

Create the following:
- `AuthCubit` - Handle authentication state
- `ProfileCubit` - Manage profile data and updates
- `PostsCubit` - Handle post CRUD operations

### 4. Add Image Picker & Upload
```dart
// For selecting profile images and posts
image_picker: ^1.0.4
```

## 🧪 Testing Recommendations

### Widget Tests
```dart
// Test profile header renders correctly
testWidgets('ProfileHeader displays user info', (tester) async {
  // ...
});

// Test stats card formatting
testWidgets('StatsCard formats large numbers', (tester) async {
  // ...
});
```

### Unit Tests
```dart
// Test user model serialization
test('UserModel toJson/fromJson', () {
  // ...
});
```

## 📱 Accessibility Features

- ✅ Minimum 48x48px touch targets for all interactive elements
- ✅ High contrast text (4.5:1 ratio)
- ✅ Semantic labels for screen readers (can be enhanced)
- ✅ Scalable text sizes
- ✅ Clear visual hierarchy

## 🎨 Customization

### Change Theme Colors
Edit `lib/core/constants/app_colors.dart`:
```dart
static const Color primary = Color(0xFF2196F3); // Your brand color
```

### Adjust Typography
Edit `lib/core/constants/app_text_styles.dart`:
```dart
static const TextStyle h1 = TextStyle(
  fontFamily: 'YourFont',
  fontSize: 32,
  // ...
);
```

### Modify Grid Layout
Edit `lib/core/constants/app_dimensions.dart`:
```dart
static const int gridCrossAxisCount = 3; // Change to 2 or 4
static const double gridSpacing = 2.0; // Adjust spacing
```

## 📝 Code Quality

- ✅ Follows Flutter clean architecture
- ✅ Separation of concerns (presentation, domain, data)
- ✅ Reusable, composable widgets
- ✅ Proper error handling
- ✅ Loading states with placeholders
- ✅ No setState() - ready for BLoC/Cubit integration
- ✅ Formatted with `dart format`
- ✅ No lint warnings
- ✅ Comprehensive comments

## 🚀 Performance Considerations

- Image caching with `NetworkImage`
- Lazy loading in grid view
- `shrinkWrap` used appropriately
- Efficient widget rebuilds
- Minimal nested widgets

## 📚 References

This implementation follows:
- [Flutter Clean Architecture](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [Material Design 3](https://m3.material.io/)
- Your "We The Artists" project proposal requirements
- Rwanda artist community needs identified in your research

## 👥 Contributors

Built for the "We The Artists" project - empowering Rwandan artists through technology.

---

**Note**: This is the Account Screen implementation. Additional screens (Home, Community, Wellness, Create Post) will follow the same architecture and design patterns.
