// 향에 적절한 이모지 반환
class EmojiHelper {
  static const Map<String, String> aromaEmojis = {
    // 견과류
    '견과류': '🥜',
    '아몬드': '🥜',
    '호두': '🥜',
    '캐슈넛': '🥜',
    '헤이즐넛': '🥜',

    // 바닐라
    '바닐라': '🍦',
    '바닐라빈': '🍦',

    // 설탕
    '설탕': '🍬',
    '캐러멜': '🍮',
    '캔디': '🍬',
    '꿀': '🍯',

    // 피트
    '피트': '🔥',
    '스모키': '💨',

    // 과일
    '과일': '🍇',
    '사과': '🍎',
    '배': '🍐',
    '체리': '🍒',
    '딸기': '🍓',
    '복숭아': '🍑',

    // 향신료
    '향신료': '🌶️',
    '시나몬': '🫙',
    '후추': '🫙',
    '정향': '🫙',
    '생강': '🫙',

    // 허브
    '허브': '🌿',
    '민트': '🌿',
    '라벤더': '🌿',

    // 곡물
    '곡물': '🌾',
    '맥아': '🌾',
    '귀리': '🌾',

    // 오크
    '오크': '🪵',
    '참나무': '🪵',
    '오크배럴': '🪵',
  };

  static const Map<String, String> tasteEmojis = {
    '단맛': '🍭',
    '신맛': '🍋',
    '쓴맛': '🍵',
    '짠맛': '🧂',
    '우마미': '🥢',

    '부드러움': '🤲',
    '강렬함': '💪',
    '균형잡힘': '⚖️',
    '풍부함': '🎆',
  };

  static const Map<String, String> finishEmojis = {
    '짧음': '👋',
    '중간': '🤝',
    '길음': '🙏',
    '매우길음': '🔄',
  };

  // 향 이름으로 이모지 찾기
  static String? getAromaEmoji(String keyword) {
    final lowerKeyword = keyword.toLowerCase();

    for (final entry in aromaEmojis.entries) {
      if (lowerKeyword.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    // 기본값
    return '👃';
  }

  // 미각 카테고리로 이모지 찾기
  static String? getTasteEmoji(String keyword) {
    final lowerKeyword = keyword.toLowerCase();

    for (final entry in tasteEmojis.entries) {
      if (lowerKeyword.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return '👅';
  }

  // 피니시 이모지 찾기
  static String? getFinishEmoji(String keyword) {
    final lowerKeyword = keyword.toLowerCase();

    for (final entry in finishEmojis.entries) {
      if (lowerKeyword.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return '🏁';
  }

  // 모든 향 카테고리 목록
  static List<String> getAromaCategories() {
    return aromaEmojis.keys.toList();
  }

  // 모든 미각 카테고리 목록
  static List<String> getTasteCategories() {
    return tasteEmojis.keys.toList();
  }

  // 모든 피니시 옵션 목록
  static List<String> getFinishOptions() {
    return finishEmojis.keys.toList();
  }
}
