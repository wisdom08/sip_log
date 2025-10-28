enum BeverageCategory { whisky, wine, makgeolli, coffee, tea }

enum Privacy { public, private }

class TastingNote {
  final String id;
  final String userId;
  final BeverageCategory category;
  final String name;
  final String brand;

  // Basic Info
  final String? region;
  final int? year;
  final String? distillery;
  final double? alcoholByVolume; // 알콜 도수 (%)

  // Visual (시각)
  final String? appearance;
  final String? appearanceEmoji;

  // Aroma (후각)
  final List<String> aromas;
  final String aromaNotes;
  final String? aromaEmoji;

  // Taste (미각)
  final List<String> tastes;
  final String tasteNotes;
  final String? tasteEmoji;

  // Finish (피니시)
  final String? finish;
  final String? finishEmoji;

  // Additional Notes
  final String? additionalNotes;

  // Ratings
  final int rating; // 0-100
  final double overallScore; // 0-5

  // Privacy
  final Privacy privacy;

  // Social
  final int likesCount;
  final List<String> likedBy;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  TastingNote({
    required this.id,
    required this.userId,
    required this.category,
    required this.name,
    required this.brand,
    this.region,
    this.year,
    this.distillery,
    this.alcoholByVolume,
    this.appearance,
    this.appearanceEmoji,
    this.aromas = const [],
    this.aromaNotes = '',
    this.aromaEmoji,
    this.tastes = const [],
    this.tasteNotes = '',
    this.tasteEmoji,
    this.finish,
    this.finishEmoji,
    this.additionalNotes,
    required this.rating,
    required this.overallScore,
    this.privacy = Privacy.private,
    this.likesCount = 0,
    this.likedBy = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category.name,
      'name': name,
      'brand': brand,
      'region': region,
      'year': year,
      'distillery': distillery,
      'alcoholByVolume': alcoholByVolume,
      'appearance': appearance,
      'appearanceEmoji': appearanceEmoji,
      'aromas': aromas,
      'aromaNotes': aromaNotes,
      'aromaEmoji': aromaEmoji,
      'tastes': tastes,
      'tasteNotes': tasteNotes,
      'tasteEmoji': tasteEmoji,
      'finish': finish,
      'finishEmoji': finishEmoji,
      'additionalNotes': additionalNotes,
      'rating': rating,
      'overallScore': overallScore,
      'privacy': privacy.name,
      'likesCount': likesCount,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TastingNote.fromJson(Map<String, dynamic> json) {
    return TastingNote(
      id: json['id'] as String,
      userId: json['userId'] as String,
      category: BeverageCategory.values.firstWhere(
        (e) => e.name == json['category'] as String,
      ),
      name: json['name'] as String,
      brand: json['brand'] as String,
      region: json['region'] as String?,
      year: json['year'] as int?,
      distillery: json['distillery'] as String?,
      alcoholByVolume: (json['alcoholByVolume'] as num?)?.toDouble(),
      appearance: json['appearance'] as String?,
      appearanceEmoji: json['appearanceEmoji'] as String?,
      aromas: List<String>.from(json['aromas'] as List),
      aromaNotes: json['aromaNotes'] as String? ?? '',
      aromaEmoji: json['aromaEmoji'] as String?,
      tastes: List<String>.from(json['tastes'] as List),
      tasteNotes: json['tasteNotes'] as String? ?? '',
      tasteEmoji: json['tasteEmoji'] as String?,
      finish: json['finish'] as String?,
      finishEmoji: json['finishEmoji'] as String?,
      additionalNotes: json['additionalNotes'] as String?,
      rating: json['rating'] as int,
      overallScore: (json['overallScore'] as num).toDouble(),
      privacy: Privacy.values.firstWhere(
        (e) => e.name == (json['privacy'] as String? ?? 'private'),
        orElse: () => Privacy.private,
      ),
      likesCount: json['likesCount'] as int? ?? 0,
      likedBy: List<String>.from(json['likedBy'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  TastingNote copyWith({
    String? id,
    String? userId,
    BeverageCategory? category,
    String? name,
    String? brand,
    String? region,
    int? year,
    String? distillery,
    String? appearance,
    String? appearanceEmoji,
    List<String>? aromas,
    String? aromaNotes,
    String? aromaEmoji,
    List<String>? tastes,
    String? tasteNotes,
    String? tasteEmoji,
    String? finish,
    String? finishEmoji,
    String? additionalNotes,
    int? rating,
    double? overallScore,
    Privacy? privacy,
    int? likesCount,
    List<String>? likedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TastingNote(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      region: region ?? this.region,
      year: year ?? this.year,
      distillery: distillery ?? this.distillery,
      alcoholByVolume: alcoholByVolume ?? this.alcoholByVolume,
      appearance: appearance ?? this.appearance,
      appearanceEmoji: appearanceEmoji ?? this.appearanceEmoji,
      aromas: aromas ?? this.aromas,
      aromaNotes: aromaNotes ?? this.aromaNotes,
      aromaEmoji: aromaEmoji ?? this.aromaEmoji,
      tastes: tastes ?? this.tastes,
      tasteNotes: tasteNotes ?? this.tasteNotes,
      tasteEmoji: tasteEmoji ?? this.tasteEmoji,
      finish: finish ?? this.finish,
      finishEmoji: finishEmoji ?? this.finishEmoji,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      rating: rating ?? this.rating,
      overallScore: overallScore ?? this.overallScore,
      privacy: privacy ?? this.privacy,
      likesCount: likesCount ?? this.likesCount,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
