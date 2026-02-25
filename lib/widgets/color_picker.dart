import 'package:flutter/material.dart';

/// ColorPicker widget for selecting album theme colors
/// Displays a palette of 12 predefined colors in a grid layout
class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  /// Predefined color palette (12 colors)
  static const List<Color> colorPalette = [
    Color(0xFFE74C3C), // Red
    Color(0xFFE67E22), // Orange
    Color(0xFFF39C12), // Yellow
    Color(0xFF2ECC71), // Green
    Color(0xFF1ABC9C), // Teal
    Color(0xFF3498DB), // Blue
    Color(0xFF9B59B6), // Purple
    Color(0xFF8E44AD), // Dark Purple
    Color(0xFFEC407A), // Pink
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF00BCD4), // Cyan
    Color(0xFF607D8B), // Grey (default)
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: colorPalette.length,
      itemBuilder: (context, index) {
        final color = colorPalette[index];
        final isSelected = color.toARGB32() == selectedColor.toARGB32();

        return Container(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onColorSelected(color),
              customBorder: const CircleBorder(),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
