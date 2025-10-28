import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/tasting_note.dart';

class NoteService {
  static const String _notesKey = 'tasting_notes';

  Future<List<TastingNote>> getAllNotes({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];

    final notes = notesJson
        .map((json) => TastingNote.fromJson(jsonDecode(json)))
        .toList();

    // Filter by user if provided
    if (userId != null) {
      return notes.where((note) => note.userId == userId).toList();
    }

    return notes;
  }

  Future<List<TastingNote>> getPublicNotes() async {
    final allNotes = await getAllNotes();
    return allNotes.where((note) => note.privacy == Privacy.public).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<TastingNote>> getUserNotes(String userId) async {
    return await getAllNotes(userId: userId);
  }

  Future<TastingNote?> getNoteById(String id) async {
    final notes = await getAllNotes();
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveNote(TastingNote note) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];

    // Remove existing note if updating
    notesJson.removeWhere((json) {
      final existingNote = TastingNote.fromJson(jsonDecode(json));
      return existingNote.id == note.id;
    });

    // Add new/updated note
    notesJson.add(jsonEncode(note.toJson()));

    await prefs.setStringList(_notesKey, notesJson);
  }

  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];

    notesJson.removeWhere((json) {
      final note = TastingNote.fromJson(jsonDecode(json));
      return note.id == id;
    });

    await prefs.setStringList(_notesKey, notesJson);
  }

  Future<void> toggleLike(String noteId, String userId) async {
    final note = await getNoteById(noteId);
    if (note == null) return;

    final likedBy = List<String>.from(note.likedBy);

    if (likedBy.contains(userId)) {
      likedBy.remove(userId);
    } else {
      likedBy.add(userId);
    }

    await saveNote(note.copyWith(likesCount: likedBy.length, likedBy: likedBy));
  }

  Future<List<TastingNote>> searchNotes({
    required String userId,
    BeverageCategory? category,
    String? keyword,
    double? minScore,
    double? maxScore,
  }) async {
    var notes = await getUserNotes(userId);

    if (category != null) {
      notes = notes.where((note) => note.category == category).toList();
    }

    if (keyword != null && keyword.isNotEmpty) {
      final lowerKeyword = keyword.toLowerCase();
      notes = notes.where((note) {
        return note.name.toLowerCase().contains(lowerKeyword) ||
            note.brand.toLowerCase().contains(lowerKeyword) ||
            note.aromaNotes.toLowerCase().contains(lowerKeyword) ||
            note.tasteNotes.toLowerCase().contains(lowerKeyword);
      }).toList();
    }

    if (minScore != null) {
      notes = notes.where((note) => note.overallScore >= minScore).toList();
    }

    if (maxScore != null) {
      notes = notes.where((note) => note.overallScore <= maxScore).toList();
    }

    // Sort by date (newest first)
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return notes;
  }
}
