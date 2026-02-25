import 'package:flutter/material.dart';
import '../models/album.dart';
import '../services/firestore_service.dart';
import 'color_picker.dart';

/// AddAlbumDialog widget for creating new albums
/// Modal dialog containing the album creation form with validation
class AddAlbumDialog extends StatefulWidget {
  final List<Album> existingAlbums;

  const AddAlbumDialog({super.key, required this.existingAlbums});

  @override
  State<AddAlbumDialog> createState() => AddAlbumDialogState();
}

@visibleForTesting
class AddAlbumDialogState extends State<AddAlbumDialog> {
  // Text editing controllers for form fields
  @visibleForTesting
  late TextEditingController nameController;
  @visibleForTesting
  late TextEditingController artistController;
  @visibleForTesting
  late TextEditingController yearController;

  // Form state variables
  @visibleForTesting
  String? selectedGenre;
  @visibleForTesting
  Color selectedColor = const Color(0xFF607D8B); // Default grey color
  @visibleForTesting
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize text editing controllers
    nameController = TextEditingController();
    artistController = TextEditingController();
    yearController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    artistController.dispose();
    yearController.dispose();
    super.dispose();
  }

  /// Default Afrobeats genres to include in the dropdown
  static const List<String> defaultGenres = [
    'Afrobeats',
    'Afro-pop',
    'Afro-fusion',
    'Alternative R&B',
  ];

  /// Generates the genre list for the dropdown
  /// Combines genres from existing albums with default genres
  /// Returns a sorted list of unique genres (Requirement 9.1, 9.2, 9.4)
  @visibleForTesting
  List<String> getGenreList() {
    // Extract unique genres from existing albums (Requirement 9.1)
    final genresFromAlbums = widget.existingAlbums.map((a) => a.genre).toSet();

    // Merge with default genres (Requirement 9.2)
    final allGenres = {...genresFromAlbums, ...defaultGenres};

    // Convert to list and sort alphabetically (Requirement 9.4)
    final sortedGenres = allGenres.toList()..sort();

    return sortedGenres;
  }

  /// Validates all form fields according to requirements
  /// Returns true if all validation rules pass
  @visibleForTesting
  bool isFormValid() {
    // Validate album name: non-empty, trimmed (Requirement 3.1)
    if (nameController.text.trim().isEmpty) {
      return false;
    }

    // Validate artist name: non-empty, trimmed (Requirement 3.2)
    if (artistController.text.trim().isEmpty) {
      return false;
    }

    // Validate release year: 4-digit format (Requirement 3.3)
    final yearText = yearController.text.trim();
    final yearInt = int.tryParse(yearText);
    if (yearInt == null || yearText.length != 4) {
      return false;
    }

    // Validate release year: range 1900 to current year + 1 (Requirement 3.4)
    final currentYear = DateTime.now().year;
    if (yearInt < 1900 || yearInt > currentYear + 1) {
      return false;
    }

    // Validate genre selection (Requirement 3.5)
    if (selectedGenre == null) {
      return false;
    }

    return true;
  }

  /// Validates form and saves album to Firestore
  /// Shows loading indicator during async operation (Requirement 12.5)
  /// Constructs Album object from form inputs (Requirements 4.2, 4.3)
  /// Closes dialog on success (Requirement 4.4)
  /// Shows error SnackBar on failure and keeps dialog open (Requirement 4.6)
  @visibleForTesting
  Future<void> validateAndSave() async {
    if (!isFormValid()) {
      return;
    }

    // Show loading indicator (Requirement 12.5)
    setState(() {
      isLoading = true;
    });

    try {
      // Construct Album object from form inputs (Requirements 4.2, 4.3)
      final newAlbum = Album(
        name: nameController.text.trim(),
        artist: artistController.text.trim(),
        color: selectedColor,
        releaseYear: int.parse(yearController.text.trim()),
        genre: selectedGenre!,
        isFavorite: false, // Default to false (Requirement 4.3)
      );

      // Call FirestoreService.addAlbum() (Requirement 4.1)
      final firestoreService = FirestoreService();
      await firestoreService.addAlbum(newAlbum);

      // Close dialog on success (Requirement 4.4)
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Show error SnackBar on failure (Requirement 4.6)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add album: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Clear loading state (keep dialog open on error)
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final genreList = getGenreList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme background
      title: const Text('Add Album', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album Name field with auto-focus (Requirement 12.1)
              TextField(
                controller: nameController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Album Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1DB954)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}), // Update button state
              ),
              const SizedBox(height: 16),

              // Artist Name field (Requirement 2.2)
              TextField(
                controller: artistController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Artist',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1DB954)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}), // Update button state
              ),
              const SizedBox(height: 16),

              // Release Year field with number keyboard (Requirement 2.3, 12.2)
              TextField(
                controller: yearController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Release Year',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1DB954)),
                  ),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}), // Update button state
              ),
              const SizedBox(height: 16),

              // Genre Dropdown (Requirement 2.4)
              DropdownButtonFormField<String>(
                value: selectedGenre,
                dropdownColor: const Color(0xFF2A2A2A),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1DB954)),
                  ),
                ),
                items: genreList.map((genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGenre = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Color Picker section (Requirement 2.5)
              const Text(
                'Album Color',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 12),
              ColorPicker(
                selectedColor: selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Cancel button (Requirement 2.7)
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        // Save button (Requirement 2.8, 3.6, 3.7, 12.5)
        TextButton(
          onPressed: isFormValid() && !isLoading ? validateAndSave : null,
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1DB954),
                    ),
                  ),
                )
              : Text(
                  'Save',
                  style: TextStyle(
                    color: isFormValid()
                        ? const Color(0xFF1DB954)
                        : Colors.grey,
                  ),
                ),
        ),
      ],
    );
  }
}
