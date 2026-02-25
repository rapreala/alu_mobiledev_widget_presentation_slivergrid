import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Album model
/// Represents a single album with its metadata
class Album {
  final String? id; // Firestore document ID
  final String name;
  final String artist;
  final Color color;
  final int releaseYear;
  final String genre;
  final bool isFavorite;

  const Album({
    this.id,
    required this.name,
    required this.artist,
    required this.color,
    required this.releaseYear,
    required this.genre,
    this.isFavorite = false,
  });

  /// Convert Album to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'artist': artist,
      'colorValue': color.value,
      'releaseYear': releaseYear,
      'genre': genre,
      'isFavorite': isFavorite,
    };
  }

  /// Create Album from Firestore document
  factory Album.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Album(
      id: doc.id,
      name: data['name'] as String,
      artist: data['artist'] as String,
      color: Color(data['colorValue'] as int),
      releaseYear: data['releaseYear'] as int,
      genre: data['genre'] as String,
      isFavorite: data['isFavorite'] as bool? ?? false,
    );
  }

  /// Create a copy of album with updated fields
  Album copyWith({
    String? id,
    String? name,
    String? artist,
    Color? color,
    int? releaseYear,
    String? genre,
    bool? isFavorite,
  }) {
    return Album(
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      color: color ?? this.color,
      releaseYear: releaseYear ?? this.releaseYear,
      genre: genre ?? this.genre,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
