import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/tasting_note.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import 'note_detail_screen.dart';
import 'filter_screen.dart';

class MyNotesScreen extends StatefulWidget {
  const MyNotesScreen({super.key});

  @override
  State<MyNotesScreen> createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 기록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: noteProvider.myNotes.isEmpty
          ? const Center(child: Text('아직 기록이 없습니다.\n+ 버튼을 눌러 기록을 추가해보세요!'))
          : RefreshIndicator(
              onRefresh: () async {
                await noteProvider.loadMyNotes(authProvider.currentUser!.id);
              },
              child: ListView.builder(
                itemCount: noteProvider.myNotes.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final note = noteProvider.myNotes[index];
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
                              const Spacer(),
                              _getPrivacyIcon(note.privacy),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                        DateFormat('MM/dd').format(note.createdAt),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(
                              noteId: note.id,
                              isMyNote: true,
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
    return Icon(icons[category] ?? Icons.local_drink);
  }

  Icon _getPrivacyIcon(Privacy privacy) {
    return Icon(
      privacy == Privacy.public ? Icons.public : Icons.lock_outline,
      size: 16,
      color: privacy == Privacy.public ? Colors.green : Colors.grey,
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('검색'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: '음료 이름, 브랜드, 향 등을 검색하세요',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _searchController.clear();
                Navigator.pop(context);
              },
              child: const Text('초기화'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('검색'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const FilterScreen()),
    );

    if (result != null && mounted) {
      // 필터 결과를 처리하여 검색 수행
      // 추후 구현 예정
    }
  }
}
