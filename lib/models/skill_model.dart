class SkillModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final int currentLevel;
  final int maxLevel;
  final int experience;
  final int experienceToNextLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.currentLevel,
    required this.maxLevel,
    required this.experience,
    required this.experienceToNextLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'currentLevel': currentLevel,
    'maxLevel': maxLevel,
    'experience': experience,
    'experienceToNextLevel': experienceToNextLevel,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    description: json['description'] as String,
    currentLevel: json['currentLevel'] as int,
    maxLevel: json['maxLevel'] as int,
    experience: json['experience'] as int,
    experienceToNextLevel: json['experienceToNextLevel'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  SkillModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    int? currentLevel,
    int? maxLevel,
    int? experience,
    int? experienceToNextLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SkillModel(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    description: description ?? this.description,
    currentLevel: currentLevel ?? this.currentLevel,
    maxLevel: maxLevel ?? this.maxLevel,
    experience: experience ?? this.experience,
    experienceToNextLevel: experienceToNextLevel ?? this.experienceToNextLevel,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
