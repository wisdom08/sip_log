import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tasting_note.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';

class AddNoteScreen extends StatefulWidget {
  final BeverageCategory category;

  const AddNoteScreen({super.key, required this.category});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic Info
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _regionController = TextEditingController();
  final _yearController = TextEditingController();
  final _distilleryController = TextEditingController();
  final _alcoholByVolumeController = TextEditingController();

  // Visual
  final _appearanceController = TextEditingController();

  // Aroma
  final _aromaNotesController = TextEditingController();

  // Taste
  final _tasteNotesController = TextEditingController();

  // Finish
  final _finishController = TextEditingController();

  // Additional Notes
  final _additionalNotesController = TextEditingController();

  // Ratings
  double _overallScore = 2.5;
  int _rating = 50;

  // Privacy
  Privacy _privacy = Privacy.private;

  // Keywords
  List<String> _aromas = [];
  List<String> _tastes = [];

  // Selected emoji
  String? _appearanceEmoji;
  String? _aromaEmoji;
  String? _tasteEmoji;
  String? _finishEmoji;

  // Available emojis for each section
  final List<String> _appearanceEmojis = [
    '🍷',
    '🥃',
    '🍺',
    '☕',
    '🍵',
    '✨',
    '💎',
  ];
  final List<String> _aromaEmojis = [
    '🥜',
    '🍦',
    '🍬',
    '🔥',
    '🍇',
    '🌶️',
    '🌿',
    '🌾',
    '🪵',
    '🍎',
    '🍑',
    '🍯',
  ];
  final List<String> _tasteEmojis = [
    '🍭',
    '🍋',
    '🍵',
    '🧂',
    '🤲',
    '💪',
    '⚖️',
    '🎆',
    '🍓',
    '🍊',
    '🍌',
  ];
  final List<String> _finishEmojis = ['👋', '🤝', '🙏', '🔄', '⚡', '🌊', '💫'];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _regionController.dispose();
    _yearController.dispose();
    _distilleryController.dispose();
    _alcoholByVolumeController.dispose();
    _appearanceController.dispose();
    _aromaNotesController.dispose();
    _tasteNotesController.dispose();
    _finishController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final noteProvider = context.read<NoteProvider>();

    final note = TastingNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: authProvider.currentUser!.id,
      category: widget.category,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      region: _regionController.text.trim().isEmpty
          ? null
          : _regionController.text.trim(),
      year: _yearController.text.trim().isEmpty
          ? null
          : int.tryParse(_yearController.text),
      distillery: _distilleryController.text.trim().isEmpty
          ? null
          : _distilleryController.text.trim(),
      alcoholByVolume: _alcoholByVolumeController.text.trim().isEmpty
          ? null
          : double.tryParse(_alcoholByVolumeController.text),
      appearance: _appearanceController.text.trim(),
      appearanceEmoji: _appearanceEmoji,
      aromas: _aromas,
      aromaNotes: _aromaNotesController.text.trim(),
      aromaEmoji: _aromaEmoji,
      tastes: _tastes,
      tasteNotes: _tasteNotesController.text.trim(),
      tasteEmoji: _tasteEmoji,
      finish: _finishController.text.trim(),
      finishEmoji: _finishEmoji,
      additionalNotes: _additionalNotesController.text.trim(),
      rating: _rating,
      overallScore: _overallScore,
      privacy: _privacy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await noteProvider.saveNote(note);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('기록이 저장되었습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getCategoryTitle())),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Info
            _buildSection('기본 정보', [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '음료 이름 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? '필수 항목입니다' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: '브랜드 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? '필수 항목입니다' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(
                  labelText: '지역',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: '연도',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              if (widget.category == BeverageCategory.whisky) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _distilleryController,
                  decoration: const InputDecoration(
                    labelText: '증류소',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ]),
            const SizedBox(height: 16),

            // 시각 이모지
            _buildSection('시각 이모지', [
              Wrap(
                spacing: 12,
                children: _appearanceEmojis.map((emoji) {
                  final isSelected = _appearanceEmoji == emoji;
                  return GestureDetector(
                    onTap: () => setState(
                      () => _appearanceEmoji = isSelected ? null : emoji,
                    ),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ]),
            const SizedBox(height: 16),

            // 후각 이모지
            _buildSection('후각 이모지', [
              Wrap(
                spacing: 12,
                children: _aromaEmojis.map((emoji) {
                  final isSelected = _aromaEmoji == emoji;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _aromaEmoji = isSelected ? null : emoji),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ]),
            const SizedBox(height: 16),

            // 미각 이모지
            _buildSection('미각 이모지', [
              Wrap(
                spacing: 12,
                children: _tasteEmojis.map((emoji) {
                  final isSelected = _tasteEmoji == emoji;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _tasteEmoji = isSelected ? null : emoji),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? Colors.orange
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ]),
            const SizedBox(height: 16),

            // 피니시 이모지
            _buildSection('피니시 이모지', [
              Wrap(
                spacing: 12,
                children: _finishEmojis.map((emoji) {
                  final isSelected = _finishEmoji == emoji;
                  return GestureDetector(
                    onTap: () => setState(
                      () => _finishEmoji = isSelected ? null : emoji,
                    ),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.purple.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? Colors.purple
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ]),
            const SizedBox(height: 16),

            // 추가 노트
            _buildSection('추가 노트', [
              TextFormField(
                controller: _additionalNotesController,
                decoration: const InputDecoration(
                  labelText: '기타 메모',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ]),
            const SizedBox(height: 16),

            // Ratings
            _buildSection('평점', [
              Text('종합 점수: ${_overallScore.toStringAsFixed(1)}/5.0'),
              Slider(
                value: _overallScore,
                min: 0,
                max: 5,
                divisions: 50,
                onChanged: (value) => setState(() => _overallScore = value),
              ),
              const SizedBox(height: 16),
              Text('레이팅: $_rating/100'),
              Slider(
                value: _rating.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) => setState(() => _rating = value.round()),
              ),
            ]),
            const SizedBox(height: 16),

            // Privacy
            _buildSection('공개 설정', [
              Row(
                children: [
                  Radio<Privacy>(
                    value: Privacy.private,
                    groupValue: _privacy,
                    onChanged: (value) => setState(() => _privacy = value!),
                  ),
                  const Text('비공개'),
                  const Spacer(),
                  Radio<Privacy>(
                    value: Privacy.public,
                    groupValue: _privacy,
                    onChanged: (value) => setState(() => _privacy = value!),
                  ),
                  const Text('공개'),
                ],
              ),
            ]),
            const SizedBox(height: 16),

            // Save button
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
            ...children,
          ],
        ),
      ),
    );
  }

  String _getCategoryTitle() {
    final titles = {
      BeverageCategory.whisky: '위스키 기록',
      BeverageCategory.wine: '와인 기록',
      BeverageCategory.makgeolli: '막걸리 기록',
      BeverageCategory.coffee: '커피 기록',
      BeverageCategory.tea: '차 기록',
    };
    return titles[widget.category] ?? '기록 추가';
  }
}
