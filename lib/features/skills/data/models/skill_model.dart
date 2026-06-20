import '../../domain/entities/skill_entity.dart';

/// Data-layer shape for a single skill. Knows about JSON; the domain layer
/// never does. Throws raw exceptions — SkillsRepositoryImpl catches them.
class SkillModel {
  final String id;
  final String name;
  final String category;
  final String categoryLabel;
  final int proficiency;
  final String description;

  const SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.proficiency,
    required this.description,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      categoryLabel: json['categoryLabel'] as String,
      proficiency: json['proficiency'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'categoryLabel': categoryLabel,
      'proficiency': proficiency,
      'description': description,
    };
  }

  SkillEntity toEntity() {
    return SkillEntity(
      id: id,
      name: name,
      category: category,
      categoryLabel: categoryLabel,
      proficiency: proficiency,
      description: description,
    );
  }
}
