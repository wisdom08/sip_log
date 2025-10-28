import 'package:flutter/foundation.dart';
import '../models/tasting_note.dart';
import '../services/note_service.dart';

class NoteProvider with ChangeNotifier {
  final NoteService _noteService = NoteService();

  List<TastingNote> _myNotes = [];
  List<TastingNote> _publicNotes = [];

  List<TastingNote> get myNotes => _myNotes;
  List<TastingNote> get publicNotes => _publicNotes;

  Future<void> loadMyNotes(String userId) async {
    _myNotes = await _noteService.getUserNotes(userId);
    notifyListeners();
  }

  Future<void> loadPublicNotes() async {
    _publicNotes = await _noteService.getPublicNotes();
    notifyListeners();
  }

  Future<void> saveNote(TastingNote note) async {
    await _noteService.saveNote(note);

    // myNotes 리스트에 추가 (로컬 상태 업데이트)
    final index = _myNotes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      _myNotes[index] = note;
    } else {
      _myNotes.insert(0, note);
    }

    // 최신순으로 정렬
    _myNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (note.privacy == Privacy.public) {
      await loadPublicNotes();
    }
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await _noteService.deleteNote(noteId);
    _myNotes.removeWhere((note) => note.id == noteId);
    _publicNotes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }

  Future<void> toggleLike(String noteId, String userId) async {
    await _noteService.toggleLike(noteId, userId);
    await loadPublicNotes();
    notifyListeners();
  }

  Future<List<TastingNote>> searchNotes({
    required String userId,
    BeverageCategory? category,
    String? keyword,
    double? minScore,
    double? maxScore,
  }) async {
    return await _noteService.searchNotes(
      userId: userId,
      category: category,
      keyword: keyword,
      minScore: minScore,
      maxScore: maxScore,
    );
  }
}
