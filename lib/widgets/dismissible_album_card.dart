import 'package:flutter/material.dart';
import '../models/album.dart';

/// Dismissible wrapper for album cards
/// Enables swipe-to-delete gesture with confirmation
class DismissibleAlbumCard extends StatelessWidget {
  final Album album;
  final Widget child;
  final Future<void> Function(Album) onDeleteConfirmed;

  const DismissibleAlbumCard({
    super.key,
    required this.album,
    required this.child,
    required this.onDeleteConfirmed,
  });

  /// Show confirmation dialog before deletion
  Future<bool?> _confirmDismiss(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text(
            'Delete Album?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete \'${album.name}\'?',
            style: const TextStyle(color: Color(0xFFB3B3B3)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFB3B3B3)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(album.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) => _confirmDismiss(context),
      onDismissed: (direction) {
        onDeleteConfirmed(album);
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      child: child,
    );
  }
}
