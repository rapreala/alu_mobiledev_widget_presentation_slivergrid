import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_grid_demo/models/album.dart';
import 'package:sliver_grid_demo/widgets/add_album_dialog.dart';

void main() {
  group('AddAlbumDialog Form Validation Tests', () {
    testWidgets('form is invalid when album name is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      // Get the state to access isFormValid
      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields except name
      state.artistController.text = 'Valid Artist';
      state.yearController.text = '2020';
      state.selectedGenre = 'Afrobeats';

      // Test with empty name
      state.nameController.text = '';
      expect(state.isFormValid(), isFalse);

      // Test with whitespace-only name
      state.nameController.text = '   ';
      expect(state.isFormValid(), isFalse);
    });

    testWidgets('form is invalid when artist name is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields except artist
      state.nameController.text = 'Valid Album';
      state.yearController.text = '2020';
      state.selectedGenre = 'Afrobeats';

      // Test with empty artist
      state.artistController.text = '';
      expect(state.isFormValid(), isFalse);

      // Test with whitespace-only artist
      state.artistController.text = '   ';
      expect(state.isFormValid(), isFalse);
    });

    testWidgets('form is invalid when year is not 4 digits', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields except year
      state.nameController.text = 'Valid Album';
      state.artistController.text = 'Valid Artist';
      state.selectedGenre = 'Afrobeats';

      // Test with 3-digit year
      state.yearController.text = '999';
      expect(state.isFormValid(), isFalse);

      // Test with 5-digit year
      state.yearController.text = '12345';
      expect(state.isFormValid(), isFalse);

      // Test with non-numeric input
      state.yearController.text = 'abcd';
      expect(state.isFormValid(), isFalse);

      // Test with empty year
      state.yearController.text = '';
      expect(state.isFormValid(), isFalse);
    });

    testWidgets('form is invalid when year is outside valid range', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields except year
      state.nameController.text = 'Valid Album';
      state.artistController.text = 'Valid Artist';
      state.selectedGenre = 'Afrobeats';

      // Test with year below 1900
      state.yearController.text = '1899';
      expect(state.isFormValid(), isFalse);

      // Test with year above current year + 1
      final currentYear = DateTime.now().year;
      state.yearController.text = (currentYear + 2).toString();
      expect(state.isFormValid(), isFalse);
    });

    testWidgets('form is valid when year is at boundary values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields
      state.nameController.text = 'Valid Album';
      state.artistController.text = 'Valid Artist';
      state.selectedGenre = 'Afrobeats';

      // Test with year at lower boundary (1900)
      state.yearController.text = '1900';
      expect(state.isFormValid(), isTrue);

      // Test with year at upper boundary (current year + 1)
      final currentYear = DateTime.now().year;
      state.yearController.text = (currentYear + 1).toString();
      expect(state.isFormValid(), isTrue);

      // Test with current year
      state.yearController.text = currentYear.toString();
      expect(state.isFormValid(), isTrue);
    });

    testWidgets('form is invalid when genre is not selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields except genre
      state.nameController.text = 'Valid Album';
      state.artistController.text = 'Valid Artist';
      state.yearController.text = '2020';
      state.selectedGenre = null;

      expect(state.isFormValid(), isFalse);
    });

    testWidgets('form is valid when all fields are valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields
      state.nameController.text = 'Valid Album';
      state.artistController.text = 'Valid Artist';
      state.yearController.text = '2020';
      state.selectedGenre = 'Afrobeats';

      expect(state.isFormValid(), isTrue);
    });

    testWidgets('form validates trimmed values for name and artist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values with leading/trailing whitespace
      state.nameController.text = '  Valid Album  ';
      state.artistController.text = '  Valid Artist  ';
      state.yearController.text = '2020';
      state.selectedGenre = 'Afrobeats';

      // Should be valid because trimmed values are non-empty
      expect(state.isFormValid(), isTrue);
    });

    testWidgets('form handles various invalid year formats', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Set valid values for all fields except year
      state.nameController.text = 'Valid Album';
      state.artistController.text = 'Valid Artist';
      state.selectedGenre = 'Afrobeats';

      // Test with decimal number
      state.yearController.text = '20.5';
      expect(state.isFormValid(), isFalse);

      // Test with negative number
      state.yearController.text = '-2020';
      expect(state.isFormValid(), isFalse);

      // Test with mixed alphanumeric
      state.yearController.text = '20a0';
      expect(state.isFormValid(), isFalse);

      // Test with special characters
      state.yearController.text = '20@0';
      expect(state.isFormValid(), isFalse);
    });

    testWidgets('form validation checks all fields independently', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      // Start with all invalid
      state.nameController.text = '';
      state.artistController.text = '';
      state.yearController.text = '';
      state.selectedGenre = null;
      expect(state.isFormValid(), isFalse);

      // Fix name only
      state.nameController.text = 'Valid Album';
      expect(state.isFormValid(), isFalse);

      // Fix artist only (name still valid)
      state.artistController.text = 'Valid Artist';
      expect(state.isFormValid(), isFalse);

      // Fix year only (name and artist still valid)
      state.yearController.text = '2020';
      expect(state.isFormValid(), isFalse);

      // Fix genre (all fields now valid)
      state.selectedGenre = 'Afrobeats';
      expect(state.isFormValid(), isTrue);
    });
  });

  group('AddAlbumDialog Genre List Generation Tests', () {
    testWidgets('genre list includes all default genres when no albums exist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Should include all default genres (Requirement 9.2)
      expect(genres, contains('Afrobeats'));
      expect(genres, contains('Afro-pop'));
      expect(genres, contains('Afro-fusion'));
      expect(genres, contains('Alternative R&B'));
      expect(genres.length, equals(4));
    });

    testWidgets('genre list includes genres from existing albums', (
      WidgetTester tester,
    ) async {
      final existingAlbums = [
        const Album(
          name: 'Album 1',
          artist: 'Artist 1',
          color: Colors.red,
          releaseYear: 2020,
          genre: 'Hip-Hop',
        ),
        const Album(
          name: 'Album 2',
          artist: 'Artist 2',
          color: Colors.blue,
          releaseYear: 2021,
          genre: 'R&B',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: existingAlbums)),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Should include genres from existing albums (Requirement 9.1)
      expect(genres, contains('Hip-Hop'));
      expect(genres, contains('R&B'));
    });

    testWidgets('genre list merges default genres with album genres', (
      WidgetTester tester,
    ) async {
      final existingAlbums = [
        const Album(
          name: 'Album 1',
          artist: 'Artist 1',
          color: Colors.red,
          releaseYear: 2020,
          genre: 'Hip-Hop',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: existingAlbums)),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Should include both default genres and album genres
      expect(genres, contains('Afrobeats'));
      expect(genres, contains('Afro-pop'));
      expect(genres, contains('Afro-fusion'));
      expect(genres, contains('Alternative R&B'));
      expect(genres, contains('Hip-Hop'));
      expect(genres.length, equals(5));
    });

    testWidgets('genre list removes duplicates', (WidgetTester tester) async {
      final existingAlbums = [
        const Album(
          name: 'Album 1',
          artist: 'Artist 1',
          color: Colors.red,
          releaseYear: 2020,
          genre: 'Afrobeats',
        ),
        const Album(
          name: 'Album 2',
          artist: 'Artist 2',
          color: Colors.blue,
          releaseYear: 2021,
          genre: 'Afrobeats',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: existingAlbums)),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Should only include 'Afrobeats' once
      expect(genres.where((g) => g == 'Afrobeats').length, equals(1));
      // Should have 4 default genres total (no duplicates)
      expect(genres.length, equals(4));
    });

    testWidgets('genre list is sorted alphabetically', (
      WidgetTester tester,
    ) async {
      final existingAlbums = [
        const Album(
          name: 'Album 1',
          artist: 'Artist 1',
          color: Colors.red,
          releaseYear: 2020,
          genre: 'Reggae',
        ),
        const Album(
          name: 'Album 2',
          artist: 'Artist 2',
          color: Colors.blue,
          releaseYear: 2021,
          genre: 'Hip-Hop',
        ),
        const Album(
          name: 'Album 3',
          artist: 'Artist 3',
          color: Colors.green,
          releaseYear: 2022,
          genre: 'Jazz',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: existingAlbums)),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Verify alphabetical sorting (Requirement 9.4)
      final sortedGenres = [...genres]..sort();
      expect(genres, equals(sortedGenres));

      // Verify specific order for known genres
      final hipHopIndex = genres.indexOf('Hip-Hop');
      final jazzIndex = genres.indexOf('Jazz');
      final reggaeIndex = genres.indexOf('Reggae');

      expect(hipHopIndex, lessThan(jazzIndex));
      expect(jazzIndex, lessThan(reggaeIndex));
    });

    testWidgets('genre list handles empty album list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: const [])),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Should still return default genres
      expect(genres.isNotEmpty, isTrue);
      expect(genres.length, equals(4));
    });

    testWidgets('genre list handles albums with same genre as default', (
      WidgetTester tester,
    ) async {
      final existingAlbums = [
        const Album(
          name: 'Album 1',
          artist: 'Artist 1',
          color: Colors.red,
          releaseYear: 2020,
          genre: 'Afrobeats',
        ),
        const Album(
          name: 'Album 2',
          artist: 'Artist 2',
          color: Colors.blue,
          releaseYear: 2021,
          genre: 'Afro-pop',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: existingAlbums)),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Should not duplicate genres that are both in defaults and albums
      expect(genres.where((g) => g == 'Afrobeats').length, equals(1));
      expect(genres.where((g) => g == 'Afro-pop').length, equals(1));
      expect(genres.length, equals(4)); // Only default genres
    });

    testWidgets('genre list handles many unique genres', (
      WidgetTester tester,
    ) async {
      final existingAlbums = [
        const Album(
          name: 'Album 1',
          artist: 'Artist 1',
          color: Colors.red,
          releaseYear: 2020,
          genre: 'Rock',
        ),
        const Album(
          name: 'Album 2',
          artist: 'Artist 2',
          color: Colors.blue,
          releaseYear: 2021,
          genre: 'Jazz',
        ),
        const Album(
          name: 'Album 3',
          artist: 'Artist 3',
          color: Colors.green,
          releaseYear: 2022,
          genre: 'Classical',
        ),
        const Album(
          name: 'Album 4',
          artist: 'Artist 4',
          color: Colors.yellow,
          releaseYear: 2023,
          genre: 'Electronic',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddAlbumDialog(existingAlbums: existingAlbums)),
        ),
      );

      final state = tester.state<AddAlbumDialogState>(
        find.byType(AddAlbumDialog),
      );

      final genres = state.getGenreList();

      // Should include all unique genres from albums plus defaults
      expect(genres.length, equals(8)); // 4 defaults + 4 unique album genres
      expect(genres, contains('Rock'));
      expect(genres, contains('Jazz'));
      expect(genres, contains('Classical'));
      expect(genres, contains('Electronic'));
    });
  });
}
