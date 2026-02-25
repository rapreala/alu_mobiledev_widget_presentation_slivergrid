# Firebase Setup Instructions

This document guides you through setting up Firebase for the Flutter SliverGridView demo app.

## Prerequisites

- Flutter SDK installed
- FlutterFire CLI installed (already available)
- A Google account for Firebase Console access

## Step 1: Create a Firebase Project (Optional)

**Note:** You can skip this step if you want `flutterfire configure` to create a project for you automatically.

If you prefer to create a Firebase project manually:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Follow the setup wizard to create your project
4. Enable Google Analytics (optional)

Alternatively, proceed directly to Step 2 and let the FlutterFire CLI create the project during configuration.

## Step 2: Run FlutterFire Configure

Run the following command in your project root directory:

```bash
flutterfire configure
```

This interactive command will:
- Prompt you to **select an existing Firebase project** OR **create a new one automatically**
- Register your Flutter app with Firebase (Android & iOS)
- Generate `lib/firebase_options.dart` with your project credentials
- Create platform-specific configuration files:
  - **Android**: `android/app/google-services.json`
  - **iOS**: `ios/Runner/GoogleService-Info.plist`

**Creating a New Project:**
- If you choose to create a new project, the CLI will prompt you for a project name
- The project will be created in your Firebase account automatically
- No need to visit Firebase Console first

**Selecting an Existing Project:**
- The CLI will list all Firebase projects in your account
- Use arrow keys to select the desired project
- Press Enter to confirm

**Important:** The command will overwrite the placeholder `lib/firebase_options.dart` file with your actual Firebase project credentials.

## Step 3: Platform-Specific Configuration

### Android Configuration

The `flutterfire configure` command automatically creates:
- `android/app/google-services.json`

**Verify the file exists:**
```bash
ls android/app/google-services.json
```

If the file is missing, download it from Firebase Console:
1. Go to Project Settings > Your apps > Android app
2. Download `google-services.json`
3. Place it in `android/app/` directory

### iOS Configuration

The `flutterfire configure` command automatically creates:
- `ios/Runner/GoogleService-Info.plist`

**Verify the file exists:**
```bash
ls ios/Runner/GoogleService-Info.plist
```

If the file is missing, download it from Firebase Console:
1. Go to Project Settings > Your apps > iOS app
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/` directory

## Step 4: Enable Cloud Firestore

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Select **Start in test mode** (for development)
4. Choose a Cloud Firestore location (select closest to your users)
5. Click **Enable**

**Security Rules (Test Mode):**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**⚠️ Warning:** Test mode allows unrestricted access. Update security rules before production deployment.

## Step 5: Verify Setup

Run the app to verify Firebase initialization:

```bash
flutter run
```

If Firebase is configured correctly:
- The app should launch without errors
- Check the console for "Firebase initialized successfully" (if logging is added)

If you see a Firebase error screen:
- Check that `firebase_options.dart` has real credentials (not placeholders)
- Verify `google-services.json` (Android) exists
- Verify `GoogleService-Info.plist` (iOS) exists
- Ensure Firestore is enabled in Firebase Console

## Step 6: Add Configuration Files to .gitignore

**Important:** Do NOT commit Firebase credentials to version control.

Add these lines to `.gitignore`:

```
# Firebase configuration files
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart
```

**Note:** For team projects, share these files securely (e.g., encrypted storage, environment variables).

## Alternative: Firebase CLI for Advanced Automation

For advanced users or CI/CD pipelines, you can use the Firebase CLI directly alongside FlutterFire CLI:

### Installation

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login
```

### Initialize Firebase in Your Project

```bash
# Initialize Firebase (run in project root)
firebase init

# Select features you want to use:
# - Firestore (for database rules)
# - Emulators (for local testing)
```

### Common Firebase CLI Commands

```bash
# Deploy Firestore security rules
firebase deploy --only firestore:rules

# Start Firebase Emulator Suite (for local testing)
firebase emulators:start

# Deploy Firestore indexes
firebase deploy --only firestore:indexes

# View project info
firebase projects:list
```

### When to Use Firebase CLI

**Use Firebase CLI for:**
- Managing Firestore security rules in version control
- Setting up Firebase Emulator Suite for local testing
- Deploying Firestore indexes for query optimization
- CI/CD pipeline integration
- Advanced Firebase features (Cloud Functions, Hosting, etc.)
- Team workflows requiring version-controlled configuration

**Use FlutterFire CLI for:**
- Initial Firebase project setup (recommended for most developers)
- Generating platform-specific configuration files
- Quick Firebase integration in Flutter apps
- Updating Firebase configuration when switching projects

### Combining Both CLIs

Most Flutter projects benefit from using both:
1. **FlutterFire CLI**: Generate initial configuration files (`flutterfire configure`)
2. **Firebase CLI**: Manage security rules, emulators, and deployment

**Example Workflow:**
```bash
# Initial setup with FlutterFire CLI
flutterfire configure

# Initialize Firebase features with Firebase CLI
firebase init firestore

# Edit firestore.rules file
# Deploy rules to Firebase
firebase deploy --only firestore:rules

# Start local emulator for testing
firebase emulators:start --only firestore
```

### CI/CD Integration

For automated deployments, add Firebase CLI to your CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Install Firebase CLI
  run: npm install -g firebase-tools

- name: Deploy Firestore Rules
  run: firebase deploy --only firestore:rules --token ${{ secrets.FIREBASE_TOKEN }}
```

**Generate CI token:**
```bash
firebase login:ci
```

This generates a token you can use in CI/CD environments without interactive login.

## Troubleshooting

### Error: "No Firebase App '[DEFAULT]' has been created"
- Ensure `Firebase.initializeApp()` is called before `runApp()`
- Check that `WidgetsFlutterBinding.ensureInitialized()` is called first

### Error: "MissingPluginException"
- Run `flutter clean`
- Run `flutter pub get`
- Rebuild the app

### Error: "FirebaseOptions have not been configured"
- Run `flutterfire configure` to generate proper credentials
- Ensure `firebase_options.dart` has real values, not placeholders

### Android Build Errors
- Ensure `google-services.json` is in `android/app/` directory
- Check that `android/build.gradle` has Google services plugin (added automatically)

### iOS Build Errors
- Ensure `GoogleService-Info.plist` is in `ios/Runner/` directory
- Open `ios/Runner.xcworkspace` in Xcode and verify the file is in the project

## Next Steps

Once Firebase is configured:
1. The app will automatically seed the database with sample albums on first launch
2. Albums will persist across app restarts
3. Real-time updates will work when data changes in Firestore

## Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
