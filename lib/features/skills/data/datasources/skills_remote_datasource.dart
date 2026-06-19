import '../models/skill_model.dart';
import '../services/skills_service.dart';

abstract class SkillsRemoteDataSource {
  Future<List<SkillModel>> fetchSkills();
}

class SkillsRemoteDataSourceImpl implements SkillsRemoteDataSource {
  final SkillsService _service;

  const SkillsRemoteDataSourceImpl(this._service);

  @override
  Future<List<SkillModel>> fetchSkills() {
    return _service.fetchSkills();
  }
}
