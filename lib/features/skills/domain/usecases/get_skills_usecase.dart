import '../../../../core/error/api_result.dart';
import '../entities/skill_entity.dart';
import '../repositories/skills_repository.dart';

class GetSkillsUseCase {
  final SkillsRepository _repository;

  const GetSkillsUseCase(this._repository);

  Future<ApiResult<List<SkillEntity>>> call() {
    return _repository.getSkills();
  }
}
