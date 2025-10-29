class QuestModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final int level;
  final Map<String, dynamic> objectives;
  final Map<String, dynamic> rewards;
  final String? questGiverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.level,
    required this.objectives,
    required this.rewards,
    this.questGiverId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'status': status,
    'level': level,
    'objectives': objectives,
    'rewards': rewards,
    'questGiverId': questGiverId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory QuestModel.fromJson(Map<String, dynamic> json) => QuestModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    status: json['status'] as String,
    level: json['level'] as int,
    objectives: Map<String, dynamic>.from(json['objectives'] as Map),
    rewards: Map<String, dynamic>.from(json['rewards'] as Map),
    questGiverId: json['questGiverId'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  QuestModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? status,
    int? level,
    Map<String, dynamic>? objectives,
    Map<String, dynamic>? rewards,
    String? questGiverId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => QuestModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    type: type ?? this.type,
    status: status ?? this.status,
    level: level ?? this.level,
    objectives: objectives ?? this.objectives,
    rewards: rewards ?? this.rewards,
    questGiverId: questGiverId ?? this.questGiverId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
