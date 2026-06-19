import '../../domain/entities/skill_entity.dart';

class SkillModel {
  final String id;
  final String name;
  final String category;
  final int proficiency;
  final String iconAsset;

  const SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    required this.iconAsset,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      proficiency: json['proficiency'] as int,
      iconAsset: json['iconAsset'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'proficiency': proficiency,
      'iconAsset': iconAsset,
    };
  }

  SkillEntity toEntity() {
    return SkillEntity(
      id: id,
      name: name,
      category: category,
      proficiency: proficiency,
      iconAsset: iconAsset,
    );
  }
}
