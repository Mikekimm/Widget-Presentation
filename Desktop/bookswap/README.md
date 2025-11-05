# 📚 BookSwap - Trade Your Textbooks With Other Students

Hey there! BookSwap is a Flutter app I built to help students swap textbooks without spending a fortune. Tired of buying expensive books you'll only use for one semester? Me too! That's why I created this.

## What Can You Do With This App?

- 🔐 **Sign up and log in** - Email verification included to keep things legit
- 📖 **Post your books** - Add books you want to swap with photos and details
- 🔄 **Request swaps** - Found a book you need? Send a swap request!
- 💬 **Chat with other students** - Coordinate pickups and discuss details
- ⚡ **Real-time updates** - Everything syncs instantly thanks to Firebase
- ⚙️ **Customize settings** - Toggle notifications and manage your profile

## How It's Built

I organized the code to keep things clean and maintainable:

```
lib/
├── models/          # Data structures (books, users, swaps)
├── services/        # Firebase communication layer
├── providers/       # State management (using Provider)
├── screens/         # All the app screens
│   ├── auth/       # Login and signup screens
│   └── ...         # Browse, chat, settings, etc.
└── widgets/         # Reusable UI components
```

## Architecture Diagram

Here's how everything connects in the app:

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI Layer (Screens)                       │
│  Login → Home → Browse Books → Book Details → Request Swap      │
│   ↓        ↓         ↓              ↓               ↓            │
│  Consumer  Consumer  Consumer    Consumer       Consumer        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                  State Management (Provider)                     │
│                                                                  │
│  AuthProvider → Manages user authentication & sessions          │
│  BookProvider → Handles book CRUD operations                    │
│  SwapProvider → Tracks swap requests & statuses                 │
│  SettingsProvider → Stores user preferences                     │
│                                                                  │
│  Each provider uses notifyListeners() to update the UI          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Services Layer                                │
│                                                                  │
│  AuthService → signIn(), signUp(), sendEmailVerification()      │
│  BookService → createBook(), updateBook(), deleteBook()         │
│  StorageService → uploadBookCover(), deleteImage()              │
│  SwapService → createSwapRequest(), acceptSwap()                │
│  ChatService → sendMessage(), getMessages()                     │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                         Firebase                                 │
│                                                                  │
│  Authentication → User login/signup with email verification     │
│  Firestore → Real-time database for books, users, swaps, chats  │
│  Storage → Book cover images (compressed, optimized)            │
│                                                                  │
│  Real-time listeners keep UI in sync with database changes      │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow Example (Creating a Book):

```
User taps "Post Book" button
       ↓
AddBookScreen captures input
       ↓
Calls BookProvider.createBook()
       ↓
BookProvider calls BookService.createBook()
       ↓
BookService uploads image to Firebase Storage
       ↓
BookService saves book data to Firestore
       ↓
Firestore triggers real-time listener
       ↓
BookProvider.notifyListeners() called
       ↓
All Consumer<BookProvider> widgets rebuild
       ↓
Book appears on Home & My Listings screens automatically!
```

## State Management - Why I Chose Provider

I went with **Provider** for managing state in this app. Here's why:

- **Super easy to learn** - I picked it up in a day
- **Efficient** - Only rebuilds the parts of the UI that actually changed
- **Flutter's recommendation** - It's officially supported, so plenty of docs and examples
- **Scales well** - Works great for apps this size, and can grow with you

### How Provider Works Here:

Think of it like this:
1. **ChangeNotifier** - Your data lives here, and it tells widgets when something changes
2. **MultiProvider** - Makes your data available throughout the app
3. **Consumer** - Widgets that listen and rebuild when data changes
4. **Provider.of** - Quick way to grab data without rebuilding

### Here's a Quick Example:

```dart
// Step 1: Create your state class
class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Hey widgets, I changed!
    
    _user = await _authService.signIn(email, password);
    _isLoading = false;
    notifyListeners(); // Update again!
  }
}

// Step 2: Make it available to your app
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => BookProvider()),
  ],
  child: MyApp(),
)

// Step 3: Use it in your widgets
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) {
      return CircularProgressIndicator();
    }
    return Text('Hello ${authProvider.user?.name}');
  },
)
```

### The Four State Managers I'm Using:

- **AuthProvider** - Handles login, signup, and user sessions
- **BookProvider** - Manages all book listings and CRUD stuff
- **SwapProvider** - Keeps track of swap requests
- **SettingsProvider** - Stores user preferences

## Firebase Setup

### Prerequisites:
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Register your app for each platform (Web, Android, iOS)

### Configuration Steps:

1. **Enable Firebase Authentication**:
   - Go to Authentication > Sign-in method
   - Enable Email/Password authentication

2. **Create Firestore Database**:
   - Go to Firestore Database
   - Create database in production mode
   - Set up security rules (see below)

3. **Add Firebase Config Files**:
   - Android: Download `google-services.json` → Place in `android/app/`
   - iOS: Download `GoogleService-Info.plist` → Place in `ios/Runner/`
   - Web: Configuration already in `lib/firebase_options.dart`

### Firestore Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /books/{bookId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.ownerId;
    }
    
    match /swaps/{swapId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.senderId 
                    || request.auth.uid == resource.data.receiverId;
    }
    
    match /chats/{chatId}/messages/{messageId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

## Installation & Running

**1. Grab the code:**
```bash
git clone https://github.com/Mikekimm/Widget-Presentation.git
cd bookswap
```

**2. Install all the Flutter packages:**
```bash
flutter pub get
```

**3. Fire it up!**
```bash
# Running on web (easiest for testing)
flutter run -d chrome

# Running on Android phone/emulator
flutter run -d android

# Running on iOS (Mac only)
flutter run -d ios
```

## What the Data Looks Like in Firestore

Here's how I structured the database. Pretty straightforward!

### users collection
```json
{
  "uid": "user123",  // Firebase assigns this
  "email": "student@example.com",
  "displayName": "John Doe",
  "emailVerified": true,  // Important for our verification feature!
  "createdAt": "2025-10-31T12:00:00.000Z"
}
```

### books collection
```json
{
  "title": "Data Structures and Algorithms",
  "author": "Thomas H. Cormen",
  "condition": "Like New",  // Good, Like New, Acceptable, etc.
  "swapFor": "Operating Systems",  // What they want in return
  "imageUrl": "https://...",  // Book cover (or placeholder)
  "ownerId": "user123",  // Who posted it
  "ownerName": "John Doe",
  "status": "available",  // available, swapped, or deleted
  "createdAt": "2025-10-31T12:00:00.000Z"
}
```

### swaps collection
```json
{
  "bookId": "book456",
  "bookTitle": "Data Structures",
  "bookImageUrl": "https://...",
  "senderId": "user123",  // Person making the swap offer
  "senderName": "John Doe",
  "receiverId": "user789",  // Book owner
  "receiverName": "Jane Smith",
  "status": "pending",  // pending, accepted, or rejected
  "createdAt": "2025-10-31T12:00:00.000Z"
}
```

### chats/{chatId}/messages subcollection
```json
{
  "chatId": "user123_user789",  // Combined user IDs
  "senderId": "user123",
  "senderName": "John Doe",
  "text": "Hi, are you interested in swapping?",
  "timestamp": "2025-10-31T12:00:00.000Z"
}
```

## Main Packages I'm Using

| Package | What It Does | Why I Picked It |
|---------|--------------|-----------------|
| firebase_core | Firebase initialization | Required for any Firebase app |
| firebase_auth | User authentication | Built-in email verification! |
| cloud_firestore | Real-time database | Auto-syncs data across devices |
| firebase_storage | Image storage | Part of Firebase ecosystem |
| provider | State management | Simple and officially recommended |
| image_picker | Select images from gallery | Works on web and mobile |
| cached_network_image | Efficient image loading | Caches images so they load fast |
| intl | Date/time formatting | Makes dates look nice |
| uuid | Generate unique IDs | For chat IDs and such |

## Trade-offs and What I Learned

### 1. Why Provider Instead of Bloc or Riverpod?
I went with Provider because:
- **Way easier to learn** - I got it working in a day
- **Officially recommended** - Flutter team suggests it for beginners
- **Good enough for this app** - No need to overcomplicate things
**The downside?** BLoC would've been better if this was a massive app with hundreds of screens.

### 2. Firebase or Build My Own Backend?
I used Firebase and here's why:
- **Real-time syncing out of the box** - Changes show up instantly on all devices
- **Zero server maintenance** - No need to manage servers or databases
- **Faster to build** - Got the backend done in a few hours

**The catch?** You're kinda locked into Firebase's ecosystem, and if you get huge traffic, costs can add up.

### 3. Making Email Verification Required
I decided to block users until they verify their email:
- **Keeps things legit** - No fake accounts with garbage emails
- **Better for trust** - You know people are who they say they are

**The annoying part?** It adds one more step before users can start using the app. Some people hate that.

### 4. Image Storage - Why I Didn't Fully Implement It
I set up Firebase Storage but kept things simple with placeholders:
- **Would be great for scale** - Can store millions of book cover images
- **Fast delivery** - Firebase has CDN built in

**The issue?** Firebase Storage requires a paid plan (Blaze), and for this demo project, placeholder images work just fine.

## Checking Code Quality

Want to see if your code follows Dart best practices? Run the analyzer:

```bash
# Check everything
flutter analyze

# Save the results to a file (handy for assignments!)
flutter analyze > analyzer_report.txt

# Automatically fix some issues
dart fix --apply
```

## Testing the App

I've included some basic tests. Here's how to run them:

```bash
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage

# Generate and view a nice HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## How I Organized the Code

```
bookswap/
├── lib/
│   ├── models/              # Data structures for users, books, etc.
│   │   ├── user_model.dart
│   │   ├── book_model.dart
│   │   ├── swap_model.dart
│   │   └── message_model.dart
│   ├── services/            # All Firebase interactions happen here
│   │   ├── auth_service.dart      # Login, signup, verification
│   │   ├── book_service.dart      # CRUD for books
│   │   ├── swap_service.dart      # Managing swap requests
│   │   └── chat_service.dart      # Real-time messaging
│   ├── providers/           # State management layer
│   │   ├── auth_provider.dart
│   │   ├── book_provider.dart
│   │   ├── swap_provider.dart
│   │   └── settings_provider.dart
│   ├── screens/             # All the app screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── home_screen.dart              # Main dashboard
│   │   ├── browse_screen.dart            # See all books
│   │   ├── my_listings_screen.dart       # Your posted books
│   │   ├── add_book_screen.dart          # Post a new book
│   │   ├── edit_book_screen.dart         # Update your listing
│   │   ├── book_detail_screen.dart       # Book details page
│   │   ├── chats_screen.dart             # All your conversations
│   │   ├── chat_detail_screen.dart       # Individual chat
│   │   └── settings_screen.dart          # User preferences
│   ├── widgets/             # Reusable UI components
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   └── book_card.dart              # Book preview card
│   ├── firebase_options.dart            # Auto-generated Firebase config
│   └── main.dart                        # App entry point
├── android/                             # Android-specific files
├── ios/                                 # iOS-specific files
├── web/                                 # Web-specific files
├── pubspec.yaml                         # Dependencies
└── README.md                            # You're reading it!
```

## About This Project

This is an academic project I built to demonstrate Flutter and Firebase integration. It's part of my coursework showing how to build a real-world mobile app with authentication, database operations, and real-time features.

## License

MIT License - feel free to use this code for learning!

## Get In Touch

**Michael Kimani** - [@Mikekimm](https://github.com/Mikekimm)

**Project Repository:** [https://github.com/Mikekimm/Widget-Presentation](https://github.com/Mikekimm/Widget-Presentation)

## Helpful Resources

If you're new to Flutter or want to learn more:
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab) - Great beginner tutorial
- [Flutter Cookbook](https://docs.flutter.dev/cookbook) - Lots of useful examples
- [Flutter Documentation](https://docs.flutter.dev/) - Full docs with tutorials and API reference

Thanks for checking out my project! 📚✨
