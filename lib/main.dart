import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/album_grid_screen.dart';
import 'services/firestore_service.dart';
import 'data/albums_data.dart';

/// Main entry point of the application
/// Initializes Firebase before running the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Seed database with initial data if empty
    final firestoreService = FirestoreService();
    if (await firestoreService.isDatabaseEmpty()) {
      await firestoreService.seedDatabase(AlbumsData.afrobeatsAlbums);
    }

    runApp(const SpotifyAlbumApp());
  } catch (e) {
    // If Firebase initialization fails, show error screen
    runApp(FirebaseErrorApp(error: e.toString()));
  }
}

/// Root widget of the application
/// Configures the app theme and navigation
class SpotifyAlbumApp extends StatelessWidget {
  const SpotifyAlbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afrobeats Albums',
      debugShowCheckedModeBanner: false,
      // Spotify-inspired dark theme
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954), // Spotify green
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
          secondary: Color(0xFF1DB954),
          surface: Color(0xFF181818),
        ),
        useMaterial3: true,
      ),
      home: const AlbumGridScreen(),
    );
  }
}

/// Error screen displayed when Firebase initialization fails
class FirebaseErrorApp extends StatelessWidget {
  final String error;

  const FirebaseErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Error',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Failed to Initialize Firebase',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please check your Firebase configuration and try again.',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
