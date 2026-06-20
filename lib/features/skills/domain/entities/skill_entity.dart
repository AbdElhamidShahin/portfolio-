/// Pure domain entity representing a single skill/technology.
/// No Flutter imports — this file is framework-agnostic.
class SkillEntity {
  final String id;
  final String name;
  final String category;      // machine key used for grouping: 'frontend', 'architecture', etc.
  final String categoryLabel; // human-readable label rendered in the UI
  final int proficiency;      // 0–100
  final String description;   // one-line context shown beneath the skill name

  const SkillEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.proficiency,
    required this.description,
  });
}
