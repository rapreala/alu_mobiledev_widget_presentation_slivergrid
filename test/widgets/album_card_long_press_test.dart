import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_grid_demo/widgets/album_card.dart';

void main() {
  group('AlbumCard Long Press', () {
    testWidgets('AlbumCard triggers onLongPress callback', (
      WidgetTester tester,
    ) async {
      bool longPressTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlbumCard(
              albumName: 'Test Album',
              artistName: 'Test Artist',
              color: Colors.blue,
              releaseYear: 2023,
              genre: 'Afrobeats',
              isFavorite: false,
              onTap: () {},
              onFavoriteToggle: () {},
              onLongPress: () {
                longPressTriggered = true;
              },
            ),
          ),
        ),
      );

      // Find the GestureDetector
      final gestureDetector = find.byType(GestureDetector).first;

      // Perform long press
      await tester.longPress(gestureDetector);
      await tester.pumpAndSettle();

      // Verify long press was triggered
      expect(longPressTriggered, true);
    });

    testWidgets('AlbumCard works without onLongPress callback', (
      WidgetTester tester,
    ) async {
      // Should not throw error when onLongPress is null
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlbumCard(
              albumName: 'Test Album',
              artistName: 'Test Artist',
              color: Colors.blue,
              releaseYear: 2023,
              genre: 'Afrobeats',
              isFavorite: false,
              onTap: () {},
              onFavoriteToggle: () {},
              // onLongPress is optional
            ),
          ),
        ),
      );

      // Find the GestureDetector
      final gestureDetector = find.byType(GestureDetector).first;

      // Perform long press - should not throw error
      await tester.longPress(gestureDetector);
      await tester.pumpAndSettle();

      // If we get here without error, the test passes
      expect(find.byType(AlbumCard), findsOneWidget);
    });

    testWidgets('AlbumCard onTap still works with onLongPress', (
      WidgetTester tester,
    ) async {
      bool tapTriggered = false;
      bool longPressTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlbumCard(
              albumName: 'Test Album',
              artistName: 'Test Artist',
              color: Colors.blue,
              releaseYear: 2023,
              genre: 'Afrobeats',
              isFavorite: false,
              onTap: () {
                tapTriggered = true;
              },
              onFavoriteToggle: () {},
              onLongPress: () {
                longPressTriggered = true;
              },
            ),
          ),
        ),
      );

      // Find the GestureDetector
      final gestureDetector = find.byType(GestureDetector).first;

      // Perform tap
      await tester.tap(gestureDetector);
      await tester.pumpAndSettle();

      // Verify tap was triggered but not long press
      expect(tapTriggered, true);
      expect(longPressTriggered, false);
    });
  });
}
