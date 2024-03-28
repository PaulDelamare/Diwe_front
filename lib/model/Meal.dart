class Meals {
  final String id;
  final String imagePath;
  final String name;
  final int calories;
  final int proteins;
  final int lipids;
  final int glucids;
  final int fibers;
  final int calcium;
  final DateTime createdAt;
  Meals({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.lipids,
    required this.glucids,
    required this.fibers,
    required this.calcium,
    required this.createdAt,
  });

  // Ajoutez cette méthode factory pour la désérialisation depuis JSON
  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      id: json['_id'],
      imagePath: json['image_path'],
      name: json['name'],
      calories: (json['calories'] ?? 0).toDouble().toInt(),
      proteins: (json['proteins'] ?? 0).toDouble().toInt(),
      lipids: (json['lipids'] ?? 0).toDouble().toInt(),
      glucids: (json['glucids'] ?? 0).toDouble().toInt(),
      fibers: (json['fibers'] ?? 0).toDouble().toInt(),
      calcium: (json['calcium'] ?? 0).toDouble().toInt(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

}
