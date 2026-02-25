# SliverGrid Demo - Afrobeats Album Grid

A Spotify-inspired album grid showcasing popular Afrobeats albums and demonstrating the **SliverGrid** widget in Flutter.

## Widget Description
SliverGrid creates a scrollable 2D grid of widgets within a CustomScrollView, perfect for displaying collections like music albums, photos, or products.

## How to Run
```bash
# Clone or download this repository
git clone <your-repo-url>

# Navigate to project directory
cd sliver_grid_demo

# Get dependencies
flutter pub get

# Run on Android emulator or device
flutter run
```

## Three Key Properties Demonstrated

### 1. `gridDelegate` (SliverGridDelegateWithFixedCrossAxisCount)
**What it does:** Controls the layout structure of the grid - defines how albums are arranged.

**In this demo:**
- `crossAxisCount: 2` → Creates 2 columns (typical for album grids)
- `mainAxisSpacing: 20.0` → 20px vertical spacing between albums
- `crossAxisSpacing: 16.0` → 16px horizontal spacing between albums
- `childAspectRatio: 0.75` → Makes cards slightly taller than wide (album cover + text)

**Try changing:**
- Change `crossAxisCount: 2` to `crossAxisCount: 3` for a more compact view
- Adjust `childAspectRatio` to change card proportions (1.0 = square, 0.5 = tall)

### 2. `delegate` (SliverChildBuilderDelegate)
**What it does:** Provides the children (album cards) for the grid using a builder function.

**In this demo:**
- Uses `SliverChildBuilderDelegate` which builds album cards on-demand (lazy loading)
- Only creates widgets for albums currently visible on screen
- More memory efficient than creating all 16 album cards at once

**Why it matters:** 
- For large music libraries (1000+ albums), this approach only builds what's visible
- Saves memory and improves scroll performance
- Essential for apps like Spotify with massive catalogs

### 3. `childCount`
**What it does:** Specifies the total number of items (albums) in the grid.

**In this demo:**
- Set dynamically to `_afrobeatsAlbums.length` (currently 16 albums)
- Automatically adjusts when you add or remove albums from the list

**Try changing:**
- Add more albums to the `_afrobeatsAlbums` list
- The grid automatically extends to show all albums
- Remove albums to see fewer items

## Featured Afrobeats Artists

This demo includes albums from popular Afrobeats artists:
- **Wizkid** - Made in Lagos, More Love Less Ego
- **Burna Boy** - African Giant, Love Damini, Twice as Tall
- **Davido** - A Better Time, Timeless
- **Asake** - Mr Money With The Vibe, Work of Art
- **Rema** - Rave & Roses
- **Ayra Starr** - 19 & Dangerous, The Year I Turned 21
- **Fireboy DML** - Playboy, Apollo
- **Omah Lay** - Boy Alone
- **Tems** - Colours and Sounds

## Real-World Use Cases
- **Music streaming apps** (Spotify, Apple Music, YouTube Music album grids)
- **E-commerce** (product catalogs on shopping apps)
- **Photo galleries** (Instagram, Google Photos grid view)
- **Video platforms** (Netflix, YouTube thumbnail grids)
- **Podcast apps** (show cover art in grid layout)
- **App stores** (app icon grids)

## Design Features
- **Spotify-inspired dark theme** with authentic colors
- **Material Design 3** components
- **Gradient album covers** simulating album art
- **Responsive grid layout** that adapts to screen size
- **Clean typography** with proper text overflow handling


## Key Code Section
The main SliverGrid implementation:
```dart
SliverGrid(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 20.0,
    crossAxisSpacing: 16.0,
    childAspectRatio: 0.75,
  ),
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      final album = _afrobeatsAlbums[index];
      return AlbumCard(
        albumName: album['album']!,
        artistName: album['artist']!,
        color: album['color'] as Color,
      );
    },
    childCount: _afrobeatsAlbums.length,
  ),
)
```

## Screenshot
![Afrobeats Album Grid Screenshot](screenshot.png)

## Resources
- [Flutter SliverGrid Documentation](https://api.flutter.dev/flutter/widgets/SliverGrid-class.html)
- [CustomScrollView Guide](https://docs.flutter.dev/cookbook/lists/mixed-list)
- [Material Design 3](https://m3.material.io/)
- [Spotify Design System](https://spotify.design/)

---

**Created by:** Ryan Apreala 
**Date:** October 28, 2025  
**Course:** Mobile Application Development - ALU  
**Theme:** Celebrating Afrobeats Music 🎵🌍
