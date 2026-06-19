import '../models/skill_model.dart';

/// Mock-only data fetching for the Skills feature.
/// Throws raw exceptions on failure; never catches them itself.
class SkillsService {
  Future<List<SkillModel>> fetchSkills() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      SkillModel(
        id: 's1',
        name: 'Flutter',
        category: 'Framework',
        proficiency: 90,
        iconAsset: 'assets/images/skills/flutter.png',
      ),
      SkillModel(
        id: 's2',
        name: 'Dart',
        category: 'Language',
        proficiency: 90,
        iconAsset: 'assets/images/skills/dart.png',
      ),
      SkillModel(
        id: 's3',
        name: 'Firebase',
        category: 'Backend',
        proficiency: 70,
        iconAsset: 'assets/images/skills/firebase.png',
      ),
    ];
  }
}
