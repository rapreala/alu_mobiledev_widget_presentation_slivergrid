import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_grid_demo/widgets/dismissible_album_card.dart';
import 'package:sliver_grid_demo/models/album.dart';

void main() {
  group('DismissibleAlbumCard', () {
    late Album testAlbum;

    setUp(() {
      testAlbum = Album(
        id: 'test-id',
        name: 'Test Album',
        artist: 'Test Artist',
        color: Colors.blue,
        releaseYear: 2023,
        genre: 'Afrobeats',
        isFavorite: false,
      );
    });

    testWidgets('shows confirmation dialog when swiped', (
      WidgetTester tester,
    ) async {
      bool deleteConfirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DismissibleAlbumCard(
              album: testAlbum,
              onDeleteConfirmed: (album) async {
                deleteConfirmed = true;
              },
              child: Container(
                key: const Key('album-card'),
                width: 100,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Swipe the card to trigger dismissal
      await tester.drag(
        find.byKey(const Key('album-card')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Delete Album?'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete \'Test Album\'?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Verify delete hasn't been called yet
      expect(deleteConfirmed, false);
    });

    testWidgets('confirmation dialog shows album name', (
      WidgetTester tester,
    ) async {
      final albumWithLongName = Album(
        id: 'test-id-2',
        name: 'Very Long Album Name That Should Be Displayed',
        artist: 'Test Artist',
        color: Colors.red,
        releaseYear: 2023,
        genre: 'Afro-pop',
        isFavorite: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DismissibleAlbumCard(
              album: albumWithLongName,
              onDeleteConfirmed: (album) async {},
              child: Container(
                key: const Key('album-card'),
                width: 100,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Swipe the card
      await tester.drag(
        find.byKey(const Key('album-card')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      // Verify album name is in the confirmation message
      expect(
        find.text(
          'Are you sure you want to delete \'Very Long Album Name That Should Be Displayed\'?',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping Cancel returns card to original position', (
      WidgetTester tester,
    ) async {
      bool deleteConfirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DismissibleAlbumCard(
              album: testAlbum,
              onDeleteConfirmed: (album) async {
                deleteConfirmed = true;
              },
              child: Container(
                key: const Key('album-card'),
                width: 100,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Swipe the card
      await tester.drag(
        find.byKey(const Key('album-card')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      // Tap Cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Delete Album?'), findsNothing);

      // Verify card is still visible (not dismissed)
      expect(find.byKey(const Key('album-card')), findsOneWidget);

      // Verify delete was not called
      expect(deleteConfirmed, false);
    });

    testWidgets('tapping Delete confirms deletion', (
      WidgetTester tester,
    ) async {
      bool deleteConfirmed = false;
      Album? deletedAlbum;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DismissibleAlbumCard(
              album: testAlbum,
              onDeleteConfirmed: (album) async {
                deleteConfirmed = true;
                deletedAlbum = album;
              },
              child: Container(
                key: const Key('album-card'),
                width: 100,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Swipe the card
      await tester.drag(
        find.byKey(const Key('album-card')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      // Tap Delete button
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Delete Album?'), findsNothing);

      // Verify delete was called with correct album
      expect(deleteConfirmed, true);
      expect(deletedAlbum, testAlbum);
    });

    testWidgets('confirmation dialog has correct styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DismissibleAlbumCard(
              album: testAlbum,
              onDeleteConfirmed: (album) async {},
              child: Container(
                key: const Key('album-card'),
                width: 100,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Swipe the card
      await tester.drag(
        find.byKey(const Key('album-card')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      // Find the AlertDialog
      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));

      // Verify dark theme styling
      expect(alertDialog.backgroundColor, const Color(0xFF282828));

      // Find the title text widget
      final titleText = tester.widget<Text>(find.text('Delete Album?'));
      expect(titleText.style?.color, Colors.white);

      // Find the Delete button text
      final deleteText = tester.widget<Text>(find.text('Delete'));
      expect(deleteText.style?.color, Colors.red);
    });

    testWidgets('swipe works in both directions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DismissibleAlbumCard(
              album: testAlbum,
              onDeleteConfirmed: (album) async {},
              child: Container(
                key: const Key('album-card'),
                width: 100,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Test left swipe
      await tester.drag(
        find.byKey(const Key('album-card')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Delete Album?'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Test right swipe
      await tester.drag(
        find.byKey(const Key('album-card')),
        const Offset(500, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Delete Album?'), findsOneWidget);
    });
  });
}
