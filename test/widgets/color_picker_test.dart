import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_grid_demo/widgets/color_picker.dart';

void main() {
  group('ColorPicker Widget Tests', () {
    testWidgets('displays all 12 predefined colors', (
      WidgetTester tester,
    ) async {
      Color selectedColor = ColorPicker.colorPalette[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // Verify that 12 color swatches (InkWell widgets) are displayed
      expect(find.byType(InkWell), findsNWidgets(12));
    });

    testWidgets('shows checkmark on selected color', (
      WidgetTester tester,
    ) async {
      Color selectedColor = ColorPicker.colorPalette[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // Verify that checkmark icon is displayed
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onColorSelected when color is tapped', (
      WidgetTester tester,
    ) async {
      Color selectedColor = ColorPicker.colorPalette[0];
      Color? tappedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {
                tappedColor = color;
              },
            ),
          ),
        ),
      );

      // Tap on the second color swatch
      await tester.tap(find.byType(InkWell).at(1));
      await tester.pump();

      // Verify that onColorSelected was called with the correct color
      expect(tappedColor, equals(ColorPicker.colorPalette[1]));
    });

    testWidgets('displays colors in 4-column grid layout', (
      WidgetTester tester,
    ) async {
      Color selectedColor = ColorPicker.colorPalette[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // Find the GridView widget
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final gridDelegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      // Verify that the grid has 4 columns
      expect(gridDelegate.crossAxisCount, equals(4));
    });

    testWidgets('circular color swatches are displayed', (
      WidgetTester tester,
    ) async {
      Color selectedColor = ColorPicker.colorPalette[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // Find all Container widgets (color swatches)
      final containers = tester.widgetList<Container>(find.byType(Container));

      // Verify that at least one container has circular shape
      final hasCircularShape = containers.any((container) {
        final decoration = container.decoration as BoxDecoration?;
        return decoration?.shape == BoxShape.circle;
      });

      expect(hasCircularShape, isTrue);
    });

    testWidgets('updates selected color when different color is tapped', (
      WidgetTester tester,
    ) async {
      Color selectedColor = ColorPicker.colorPalette[0];

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: ColorPicker(
                  selectedColor: selectedColor,
                  onColorSelected: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // Initially, checkmark should be on first color
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap on the third color swatch
      await tester.tap(find.byType(InkWell).at(2));
      await tester.pumpAndSettle();

      // Verify that checkmark is still displayed (now on the third color)
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('has ripple effect on tap', (WidgetTester tester) async {
      Color selectedColor = ColorPicker.colorPalette[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // Verify that InkWell widgets are present (they provide ripple effect)
      expect(find.byType(InkWell), findsNWidgets(12));

      // Verify that InkWell has CircleBorder for circular ripple
      final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
      expect(inkWell.customBorder, isA<CircleBorder>());
    });
  });
}
