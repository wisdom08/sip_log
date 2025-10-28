import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tasting_note.dart';
import '../providers/note_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();

    if (noteProvider.myNotes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('통계')),
        body: Center(child: Text('기록을 추가하면 통계가 표시됩니다.')),
      );
    }

    // 통계 계산
    final totalNotes = noteProvider.myNotes.length;
    final avgScore =
        noteProvider.myNotes
            .map((n) => n.overallScore)
            .reduce((a, b) => a + b) /
        totalNotes;

    // 카테고리별 통계
    final categoryCounts = <BeverageCategory, int>{};
    for (final note in noteProvider.myNotes) {
      categoryCounts[note.category] = (categoryCounts[note.category] ?? 0) + 1;
    }

    // 베스트 5, 워스트 5
    final sortedNotes = List<TastingNote>.from(noteProvider.myNotes);
    sortedNotes.sort((a, b) => b.overallScore.compareTo(a.overallScore));
    final best5 = sortedNotes.take(5).toList();
    final worst5 = sortedNotes.reversed.take(5).toList();

    final latest5 = List<TastingNote>.from(noteProvider.myNotes);
    latest5.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latest = latest5.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('통계')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 전체 통계 카드
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '전체 통계',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem('총 기록', totalNotes.toString()),
                      _StatItem('평균 점수', avgScore.toStringAsFixed(1)),
                      _StatItem('카테고리', categoryCounts.length.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 카테고리별 통계
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '카테고리별 통계',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...categoryCounts.entries.map((entry) {
                    final categoryLabels = {
                      BeverageCategory.whisky: '위스키',
                      BeverageCategory.wine: '와인',
                      BeverageCategory.makgeolli: '막걸리',
                      BeverageCategory.coffee: '커피',
                      BeverageCategory.tea: '차',
                    };
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(categoryLabels[entry.key] ?? entry.key.name),
                          const Spacer(),
                          Text('${entry.value}개'),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 베스트 5
          _SectionList(title: '베스트 5', notes: best5),
          const SizedBox(height: 16),

          // 워스트 5
          _SectionList(title: '워스트 5', notes: worst5),
          const SizedBox(height: 16),

          // 최근 5개
          _SectionList(title: '최근 5개', notes: latest),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }
}

class _SectionList extends StatelessWidget {
  final String title;
  final List<TastingNote> notes;

  const _SectionList({required this.title, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (notes.isEmpty)
              const Text('기록이 없습니다.')
            else
              ...notes.asMap().entries.map((entry) {
                final index = entry.key;
                final note = entry.value;
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(note.name),
                  subtitle: Text(note.brand),
                  trailing: Text('${note.overallScore}/5.0'),
                );
              }),
          ],
        ),
      ),
    );
  }
}
