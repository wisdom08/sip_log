import 'package:flutter/material.dart';
import '../models/tasting_note.dart';

class FilterScreen extends StatefulWidget {
  final BeverageCategory? initialCategory;
  final String? initialKeyword;
  final double? initialMinScore;
  final double? initialMaxScore;

  const FilterScreen({
    super.key,
    this.initialCategory,
    this.initialKeyword,
    this.initialMinScore,
    this.initialMaxScore,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  BeverageCategory? _selectedCategory;
  String? _keyword;
  double? _minScore;
  double? _maxScore;
  SortOption _sortOption = SortOption.dateDesc;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _keyword = widget.initialKeyword;
    _minScore = widget.initialMinScore;
    _maxScore = widget.initialMaxScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('필터 및 정렬'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _keyword = null;
                _minScore = null;
                _maxScore = null;
                _sortOption = SortOption.dateDesc;
              });
            },
            child: const Text('초기화'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 카테고리 필터
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '카테고리',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final category in BeverageCategory.values)
                        FilterChip(
                          label: Text(_getCategoryLabel(category)),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 평점 범위
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '평점 범위',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('최소: ${_minScore ?? 0.0}'),
                  RangeSlider(
                    values: RangeValues(_minScore ?? 0.0, _maxScore ?? 5.0),
                    min: 0,
                    max: 5,
                    divisions: 50,
                    onChanged: (values) {
                      setState(() {
                        _minScore = values.start;
                        _maxScore = values.end;
                      });
                    },
                  ),
                  Text('최대: ${_maxScore ?? 5.0}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 정렬 옵션
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '정렬',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...SortOption.values.map((option) {
                    return RadioListTile<SortOption>(
                      title: Text(_getSortLabel(option)),
                      value: option,
                      groupValue: _sortOption,
                      onChanged: (value) {
                        setState(() {
                          _sortOption = value!;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 적용 버튼
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'category': _selectedCategory,
                'keyword': _keyword,
                'minScore': _minScore,
                'maxScore': _maxScore,
                'sortOption': _sortOption,
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('필터 적용'),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(BeverageCategory category) {
    final labels = {
      BeverageCategory.whisky: '위스키',
      BeverageCategory.wine: '와인',
      BeverageCategory.makgeolli: '막걸리',
      BeverageCategory.coffee: '커피',
      BeverageCategory.tea: '차',
    };
    return labels[category] ?? category.name;
  }

  String _getSortLabel(SortOption option) {
    final labels = {
      SortOption.dateDesc: '최신순',
      SortOption.dateAsc: '오래된순',
      SortOption.scoreDesc: '높은 평점순',
      SortOption.scoreAsc: '낮은 평점순',
      SortOption.nameAsc: '가나다순 (이름)',
    };
    return labels[option] ?? option.name;
  }
}

enum SortOption { dateDesc, dateAsc, scoreDesc, scoreAsc, nameAsc }
