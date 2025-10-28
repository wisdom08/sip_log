import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tasting_note.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;
  final bool isMyNote;

  const NoteDetailScreen({
    super.key,
    required this.noteId,
    required this.isMyNote,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  TastingNote? _note;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final noteProvider = context.read<NoteProvider>();
    final authProvider = context.read<AuthProvider>();

    if (widget.isMyNote) {
      final myNotes = noteProvider.myNotes;
      setState(() => _note = myNotes.firstWhere((n) => n.id == widget.noteId));
    } else {
      await noteProvider.loadPublicNotes();
      final publicNotes = noteProvider.publicNotes;
      setState(
        () => _note = publicNotes.firstWhere((n) => n.id == widget.noteId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_note == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final authProvider = context.watch<AuthProvider>();
    final isLiked = _note!.likedBy.contains(authProvider.currentUser?.id ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(_note!.name),
        actions: [
          IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: () async {
              final noteProvider = context.read<NoteProvider>();
              await noteProvider.toggleLike(
                _note!.id,
                authProvider.currentUser!.id,
              );
              setState(() => _loadNote());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _note!.brand,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _getCategoryChip(_note!.category),
                        const SizedBox(width: 8),
                        Text(
                          '${_note!.overallScore}/5.0',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    if (_note!.region != null) ...[
                      const SizedBox(height: 8),
                      Text('지역: ${_note!.region}'),
                    ],
                    if (_note!.year != null) ...[Text('연도: ${_note!.year}')],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Visual (시각)
            if (_note!.appearance != null)
              _buildSection(
                '시각',
                _note!.appearance ?? '',
                _note!.appearanceEmoji,
              ),

            // Aroma (후각)
            if (_note!.aromaNotes.isNotEmpty || _note!.aromas.isNotEmpty)
              _buildSection(
                '후각',
                _note!.aromaNotes,
                _note!.aromaEmoji,
                keywords: _note!.aromas,
              ),

            // Taste (미각)
            if (_note!.tasteNotes.isNotEmpty || _note!.tastes.isNotEmpty)
              _buildSection(
                '미각',
                _note!.tasteNotes,
                _note!.tasteEmoji,
                keywords: _note!.tastes,
              ),

            // Finish
            if (_note!.finish != null)
              _buildSection('피니시', _note!.finish ?? '', _note!.finishEmoji),

            const SizedBox(height: 16),

            // Social
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('${_note!.likesCount}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    String notes,
    String? emoji, {
    List<String>? keywords,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (emoji != null) ...[
                  const SizedBox(width: 8),
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                ],
              ],
            ),
            const SizedBox(height: 8),
            if (notes.isNotEmpty) Text(notes),
            if (keywords != null && keywords.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: keywords
                    .map(
                      (keyword) => Chip(
                        label: Text(keyword),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getCategoryChip(BeverageCategory category) {
    final labels = {
      BeverageCategory.whisky: '위스키',
      BeverageCategory.wine: '와인',
      BeverageCategory.makgeolli: '막걸리',
      BeverageCategory.coffee: '커피',
      BeverageCategory.tea: '차',
    };

    return Chip(
      label: Text(labels[category] ?? category.name),
      backgroundColor: Colors.blue.shade50,
    );
  }
}
