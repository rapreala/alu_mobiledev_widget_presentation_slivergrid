import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Individual album card widget
/// Displays a single album with cover art, title, artist, year, and genre
class AlbumCard extends StatelessWidget {
  final String albumName;
  final String artistName;
  final Color color;
  final int releaseYear;
  final String genre;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onLongPress;

  const AlbumCard({
    super.key,
    required this.albumName,
    required this.artistName,
    required this.color,
    required this.releaseYear,
    required this.genre,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album cover art with favorite button
          Expanded(
            child: Stack(
              children: [
                // Album cover
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withValues(alpha: 0.6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.album,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),

                // Favorite button (top-right corner)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Genre tag (bottom-left corner)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Album name
          Text(
            albumName,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Artist name and year
          Row(
            children: [
              Expanded(
                child: Text(
                  artistName,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '• $releaseYear',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
