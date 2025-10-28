import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tasting_note.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../screens/auth/login_screen.dart';
import 'my_notes_screen.dart';
import 'community_screen.dart';
import 'stats_screen.dart';
import 'add_note_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authProvider = context.read<AuthProvider>();
    final noteProvider = context.read<NoteProvider>();

    if (authProvider.isAuthenticated) {
      noteProvider.loadMyNotes(authProvider.currentUser!.id);
      noteProvider.loadPublicNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: const [MyNotesScreen(), StatsScreen(), CommunityScreen()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.book), label: '나의 기록'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: '커뮤니티'),
            ],
            type: BottomNavigationBarType.fixed,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddNoteBottomSheet(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddNoteBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddNoteSheet(),
    );

    // 기록 추가 후 데이터 다시 로드
    if (mounted) {
      _loadData();
    }
  }
}

// Beverage Category Selection Sheet
class AddNoteSheet extends StatefulWidget {
  const AddNoteSheet({super.key});

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  BeverageCategory? _selectedCategory;

  final Map<BeverageCategory, String> _categoryLabels = {
    BeverageCategory.whisky: '위스키',
    BeverageCategory.wine: '와인',
    BeverageCategory.makgeolli: '막걸리',
    BeverageCategory.coffee: '커피',
    BeverageCategory.tea: '차',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              '음료 카테고리 선택',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: BeverageCategory.values.length,
              itemBuilder: (context, index) {
                final category = BeverageCategory.values[index];
                final isSelected = _selectedCategory == category;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isSelected ? Colors.blue.shade50 : null,
                  child: ListTile(
                    title: Text(
                      _categoryLabels[category] ?? category.name,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : const Icon(Icons.check_circle_outline),
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _selectedCategory == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddNoteScreen(category: _selectedCategory!),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('다음'),
            ),
          ),
        ],
      ),
    );
  }
}
