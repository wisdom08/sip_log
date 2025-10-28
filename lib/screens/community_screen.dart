import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/tasting_note.dart';
import '../providers/note_provider.dart';
import 'note_detail_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    _loadPublicNotes();
  }

  Future<void> _loadPublicNotes() async {
    final noteProvider = context.read<NoteProvider>();
    await noteProvider.loadPublicNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('커뮤니티')),
      body: RefreshIndicator(
        onRefresh: _loadPublicNotes,
        child: noteProvider.publicNotes.isEmpty
            ? const Center(child: Text('공개된 기록이 없습니다.'))
            : ListView.builder(
                itemCount: noteProvider.publicNotes.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final note = noteProvider.publicNotes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        note.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.brand),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _getCategoryIcon(note.category),
                              const SizedBox(width: 8),
                              Text('${note.overallScore}/5.0'),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(Icons.favorite_outline, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${note.likesCount}'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.public,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MM/dd').format(note.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(
                              noteId: note.id,
                              isMyNote: false,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Icon _getCategoryIcon(BeverageCategory category) {
    final icons = {
      BeverageCategory.whisky: Icons.local_bar,
      BeverageCategory.wine: Icons.wine_bar,
      BeverageCategory.makgeolli: Icons.emoji_food_beverage,
      BeverageCategory.coffee: Icons.coffee,
      BeverageCategory.tea: Icons.coffee_maker,
    };
    return Icon(icons[category] ?? Icons.local_drink, size: 16);
  }
}
