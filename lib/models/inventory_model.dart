class InventoryModel {
  final String id;
  final String characterId;
  final List<InventoryItem> items;
  final int maxCapacity;
  final int credits;
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryModel({
    required this.id,
    required this.characterId,
    required this.items,
    required this.maxCapacity,
    required this.credits,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'characterId': characterId,
    'items': items.map((e) => e.toJson()).toList(),
    'maxCapacity': maxCapacity,
    'credits': credits,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
    id: json['id'] as String,
    characterId: json['characterId'] as String,
    items: (json['items'] as List).map((e) => InventoryItem.fromJson(e as Map<String, dynamic>)).toList(),
    maxCapacity: json['maxCapacity'] as int,
    credits: json['credits'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  InventoryModel copyWith({
    String? id,
    String? characterId,
    List<InventoryItem>? items,
    int? maxCapacity,
    int? credits,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InventoryModel(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    items: items ?? this.items,
    maxCapacity: maxCapacity ?? this.maxCapacity,
    credits: credits ?? this.credits,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class InventoryItem {
  final String itemId;
  final int quantity;
  final bool isEquipped;

  InventoryItem({required this.itemId, required this.quantity, this.isEquipped = false});

  Map<String, dynamic> toJson() => {'itemId': itemId, 'quantity': quantity, 'isEquipped': isEquipped};

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    itemId: json['itemId'] as String,
    quantity: json['quantity'] as int,
    isEquipped: json['isEquipped'] as bool? ?? false,
  );
}
