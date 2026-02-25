import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/album.dart';

/// Service layer for managing all Firestore operations.
/// Handles CRUD operations for albums and provides real-time data streams.
class FirestoreService {
  /// Firestore instance for database operations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection name for albums in Firestore
  final String _collectionName = 'albums';

  /// Get real-time stream of all albums from Firestore
  /// Returns a Stream that emits a new list whenever the albums collection changes
  /// Automatically maps Firestore documents to Album objects
  Stream<List<Album>> getAlbumsStream() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Album.fromFirestore(doc)).toList(),
        )
        .handleError((error) {
          // Log error but allow stream to continue
          debugPrint('Error in albums stream: $error');
          throw Exception('Failed to load albums: $error');
        });
  }

  /// Add a new album to Firestore
  /// Accepts an Album object and persists it to the albums collection
  /// Returns a Future that completes when the operation succeeds
  /// Throws an exception if the operation fails
  Future<void> addAlbum(Album album) async {
    try {
      await _firestore.collection(_collectionName).add(album.toFirestore());
    } catch (e) {
      debugPrint('Error adding album: $e');
      throw Exception('Failed to add album: $e');
    }
  }

  /// Delete an album from Firestore by document ID
  /// Accepts a document ID string and removes the corresponding album
  /// Returns a Future that completes when the operation succeeds
  /// Throws an exception if the operation fails
  Future<void> deleteAlbum(String albumId) async {
    try {
      await _firestore.collection(_collectionName).doc(albumId).delete();
    } catch (e) {
      debugPrint('Error deleting album: $e');
      throw Exception('Failed to delete album: $e');
    }
  }

  /// Update the favorite status of an album in Firestore
  /// Accepts a document ID and boolean isFavorite value
  /// Updates only the isFavorite field without replacing the entire document
  /// Returns a Future that completes when the operation succeeds
  /// Throws an exception if the operation fails
  Future<void> updateFavoriteStatus(String albumId, bool isFavorite) async {
    try {
      await _firestore.collection(_collectionName).doc(albumId).update({
        'isFavorite': isFavorite,
      });
    } catch (e) {
      debugPrint('Error updating favorite status: $e');
      throw Exception('Failed to update favorite status: $e');
    }
  }

  /// Check if the albums collection is empty
  /// Returns true if the collection has no documents, false otherwise
  /// Used to determine if database seeding is needed
  Future<bool> isDatabaseEmpty() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .limit(1)
          .get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      debugPrint('Error checking if database is empty: $e');
      throw Exception('Failed to check database status: $e');
    }
  }

  /// Seed the database with initial album data
  /// Adds all albums from AlbumsData.afrobeatsAlbums to Firestore
  /// Uses batch write for efficiency when adding multiple albums
  /// Should only be called when the database is empty
  Future<void> seedDatabase(List<Album> albums) async {
    try {
      // Use batch write for efficiency
      final batch = _firestore.batch();

      for (final album in albums) {
        final docRef = _firestore.collection(_collectionName).doc();
        batch.set(docRef, album.toFirestore());
      }

      await batch.commit();
      debugPrint('Successfully seeded database with ${albums.length} albums');
    } catch (e) {
      debugPrint('Error seeding database: $e');
      throw Exception('Failed to seed database: $e');
    }
  }
}
