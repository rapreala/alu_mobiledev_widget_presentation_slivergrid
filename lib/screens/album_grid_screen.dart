import 'package:flutter/material.dart';
import '../models/album.dart';
import '../widgets/album_card.dart';
import '../widgets/add_album_dialog.dart';
import '../widgets/dismissible_album_card.dart';
import '../constants/app_colors.dart';
import '../services/firestore_service.dart';

/// Main screen displaying Afrobeats albums using SliverGrid
/// Demonstrates the three key properties of SliverGrid widget
/// Now with search, filter, and favorite functionality
class AlbumGridScreen extends StatefulWidget {
  const AlbumGridScreen({super.key});

  @override
  State<AlbumGridScreen> createState() => _AlbumGridScreenState();
}

class _AlbumGridScreenState extends State<AlbumGridScreen> {
  // Firestore service for data operations
  final FirestoreService _firestoreService = FirestoreService();

  // Search query
  String _searchQuery = '';

  // Selected genre filter
  String _selectedGenre = 'All';

  // Get unique genres from albums
  List<String> _getGenres(List<Album> albums) {
    final genres = albums.map((album) => album.genre).toSet().toList();
    genres.insert(0, 'All');
    return genres;
  }

  // Filter albums based on search and genre
  List<Album> _filterAlbums(List<Album> albums) {
    return albums.where((album) {
      // Search filter
      final matchesSearch =
          album.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          album.artist.toLowerCase().contains(_searchQuery.toLowerCase());

      // Genre filter
      final matchesGenre =
          _selectedGenre == 'All' || album.genre == _selectedGenre;

      return matchesSearch && matchesGenre;
    }).toList();
  }

  /// Handle album tap - simulate playing album
  void _playAlbum(Album album) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Row(
          children: [
            Icon(
              Icons.play_circle_filled,
              color: AppColors.spotifyGreen,
              size: 32,
            ),
            const SizedBox(width: 12),
            const Text(
              'Now Playing',
              style: TextStyle(color: AppColors.primaryText),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              album.name,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'by ${album.artist}',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              '${album.releaseYear} • ${album.genre}',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.spotifyGreen),
            ),
          ),
        ],
      ),
    );
  }

  /// Toggle favorite status
  void _toggleFavorite(Album album) async {
    try {
      // Update favorite status in Firestore
      await _firestoreService.updateFavoriteStatus(
        album.id!,
        !album.isFavorite,
      );

      // Show success feedback
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            album.isFavorite
                ? 'Removed ${album.name} from favorites'
                : 'Added ${album.name} to favorites ❤️',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.cardBackground,
        ),
      );
    } catch (e) {
      // Show error feedback
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update favorite: $e'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Delete album from Firestore
  /// Requirement 7.1: Calls FirestoreService.deleteAlbum() with album's document ID
  /// Requirement 7.3: Shows success SnackBar on successful deletion
  /// Requirement 7.4: Shows error SnackBar on failure
  /// Requirement 7.5: Album card remains visible on failure
  Future<void> _deleteAlbum(Album album) async {
    try {
      // Call FirestoreService to delete the album
      await _firestoreService.deleteAlbum(album.id!);

      // Show success feedback
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted ${album.name}'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.spotifyGreen,
        ),
      );
    } catch (e) {
      // Show error feedback
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete album: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show delete confirmation dialog
  /// Requirement 6.1: Shows confirmation dialog before deletion
  /// Requirement 6.2: Shows album name being deleted
  /// Requirement 6.3: Displays "Delete Album?" as title
  /// Requirement 6.4: Includes Cancel button
  /// Requirement 6.5: Includes Delete button
  Future<bool> _showDeleteConfirmation(Album album) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Delete Album?',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Text(
          'Are you sure you want to delete \'${album.name}\'?',
          style: TextStyle(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Handle long-press on album card
  /// Requirement 8.1: Shows context menu or action sheet on long-press
  /// Requirement 8.2: Includes "Delete Album" option
  /// Requirement 8.3: Shows confirmation dialog when selected
  /// Requirement 8.4: Follows same confirmation and persistence logic as swipe-to-delete
  void _handleLongPress(Album album) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.secondaryText,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Album info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          album.color,
                          album.color.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.album,
                      size: 24,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.name,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          album.artist,
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.secondaryText),
            // Delete option
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Album', style: TextStyle(color: Colors.red)),
              onTap: () async {
                // Close the bottom sheet
                Navigator.pop(context);
                // Show confirmation dialog
                final confirmed = await _showDeleteConfirmation(album);
                if (confirmed) {
                  await _deleteAlbum(album);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Show AddAlbumDialog for creating new albums
  /// Requirement 1.5: Opens Album_Form_Dialog when FAB is tapped
  void _showAddAlbumDialog(List<Album> albums) {
    showDialog(
      context: context,
      builder: (context) => AddAlbumDialog(existingAlbums: albums),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Album>>(
        stream: _firestoreService.getAlbumsStream(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.spotifyGreen),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading albums',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.spotifyGreen,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Get albums from stream
          final albums = snapshot.data ?? [];

          // Empty state (no albums in database)
          // Requirement 11.2: Display "No albums found" as primary message
          // Requirement 11.3: Display "Tap the + button to add your first album" as secondary guidance
          // Requirement 11.1: Empty state message mentions the Add_Album_Button
          // Requirement 11.4: FAB remains visible and functional in empty state
          if (albums.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.album, size: 64, color: AppColors.secondaryText),
                    const SizedBox(height: 16),
                    Text(
                      'No albums found',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first album',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Filter albums based on search and genre
          final filteredAlbums = _filterAlbums(albums);
          final genres = _getGenres(albums);
          final favoriteCount = albums.where((a) => a.isFavorite).length;

          return CustomScrollView(
            slivers: [
              // Spotify-style app bar
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.darkBackground,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      const Text(
                        'Afrobeats Albums',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (favoriteCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$favoriteCount',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  centerTitle: false,
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: AppColors.primaryText),
                    decoration: InputDecoration(
                      hintText: 'Search albums or artists...',
                      hintStyle: TextStyle(color: AppColors.secondaryText),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.secondaryText,
                      ),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              // Genre filter chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      final genre = genres[index];
                      final isSelected = genre == _selectedGenre;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedGenre = genre;
                            });
                          },
                          backgroundColor: AppColors.cardBackground,
                          selectedColor: AppColors.spotifyGreen,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.secondaryText,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Results count
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    '${filteredAlbums.length} album${filteredAlbums.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              // ========================================
              // MAIN WIDGET: SliverGrid
              // ========================================
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: filteredAlbums.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: AppColors.secondaryText,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No albums found',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverGrid(
                        // PROPERTY 1: gridDelegate
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20.0,
                              crossAxisSpacing: 16.0,
                              childAspectRatio: 0.75,
                            ),

                        // PROPERTY 2: delegate
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final album = filteredAlbums[index];
                            return DismissibleAlbumCard(
                              album: album,
                              onDeleteConfirmed: _deleteAlbum,
                              child: AlbumCard(
                                albumName: album.name,
                                artistName: album.artist,
                                color: album.color,
                                releaseYear: album.releaseYear,
                                genre: album.genre,
                                isFavorite: album.isFavorite,
                                onTap: () => _playAlbum(album),
                                onFavoriteToggle: () => _toggleFavorite(album),
                                onLongPress: () => _handleLongPress(album),
                              ),
                            );
                          },
                          // PROPERTY 3: childCount - derived from stream data
                          childCount: filteredAlbums.length,
                        ),
                      ),
              ),

              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          );
        },
      ),
      // Requirement 1.1: Add_Album_Button displayed as floating action button
      // Requirement 1.2: Positioned in bottom-right corner
      // Requirement 1.3: Uses plus icon (Icons.add)
      // Requirement 1.4: Uses Spotify green accent color
      floatingActionButton: StreamBuilder<List<Album>>(
        stream: _firestoreService.getAlbumsStream(),
        builder: (context, snapshot) {
          final albums = snapshot.data ?? [];
          return FloatingActionButton(
            onPressed: () => _showAddAlbumDialog(albums),
            backgroundColor: AppColors.spotifyGreen,
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
