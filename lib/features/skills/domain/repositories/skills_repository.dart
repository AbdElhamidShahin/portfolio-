import '../../../../core/error/api_result.dart';
import '../entities/skill_entity.dart';

abstract class SkillsRepository {
  Future<ApiResult<List<SkillEntity>>> getSkills();
}
