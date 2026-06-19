/// Pure domain entity representing a single skill/technology.
class SkillEntity {
  final String id;
  final String name;
  final String category;
  final int proficiency; // 0-100
  final String iconAsset;

  const SkillEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    required this.iconAsset,
  });
}
