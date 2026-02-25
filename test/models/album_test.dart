import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_grid_demo/models/album.dart';

void main() {
  group('Album copyWith', () {
    test('copyWith preserves all fields when no parameters provided', () {
      final album = Album(
        id: 'test-id',
        name: 'Test Album',
        artist: 'Test Artist',
        color: Colors.blue,
        releaseYear: 2020,
        genre: 'Afrobeats',
        isFavorite: true,
      );

      final copied = album.copyWith();

      expect(copied.id, album.id);
      expect(copied.name, album.name);
      expect(copied.artist, album.artist);
      expect(copied.color, album.color);
      expect(copied.releaseYear, album.releaseYear);
      expect(copied.genre, album.genre);
      expect(copied.isFavorite, album.isFavorite);
    });

    test('copyWith updates only specified fields', () {
      final album = Album(
        id: 'test-id',
        name: 'Test Album',
        artist: 'Test Artist',
        color: Colors.blue,
        releaseYear: 2020,
        genre: 'Afrobeats',
        isFavorite: false,
      );

      final copied = album.copyWith(name: 'Updated Album', isFavorite: true);

      expect(copied.id, album.id);
      expect(copied.name, 'Updated Album');
      expect(copied.artist, album.artist);
      expect(copied.color, album.color);
      expect(copied.releaseYear, album.releaseYear);
      expect(copied.genre, album.genre);
      expect(copied.isFavorite, true);
    });

    test('copyWith can update all fields', () {
      final album = Album(
        id: 'test-id',
        name: 'Test Album',
        artist: 'Test Artist',
        color: Colors.blue,
        releaseYear: 2020,
        genre: 'Afrobeats',
        isFavorite: false,
      );

      final copied = album.copyWith(
        id: 'new-id',
        name: 'New Album',
        artist: 'New Artist',
        color: Colors.red,
        releaseYear: 2021,
        genre: 'Afro-pop',
        isFavorite: true,
      );

      expect(copied.id, 'new-id');
      expect(copied.name, 'New Album');
      expect(copied.artist, 'New Artist');
      expect(copied.color, Colors.red);
      expect(copied.releaseYear, 2021);
      expect(copied.genre, 'Afro-pop');
      expect(copied.isFavorite, true);
    });

    test('copyWith creates a new instance (immutability)', () {
      final album = Album(
        id: 'test-id',
        name: 'Test Album',
        artist: 'Test Artist',
        color: Colors.blue,
        releaseYear: 2020,
        genre: 'Afrobeats',
        isFavorite: false,
      );

      final copied = album.copyWith(isFavorite: true);

      expect(identical(album, copied), false);
      expect(album.isFavorite, false);
      expect(copied.isFavorite, true);
    });
  });
}
