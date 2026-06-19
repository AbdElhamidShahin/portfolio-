import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/skill_entity.dart';
import '../../domain/repositories/skills_repository.dart';
import '../datasources/skills_remote_datasource.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  final SkillsRemoteDataSource _dataSource;

  const SkillsRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<List<SkillEntity>>> getSkills() async {
    try {
      final models = await _dataSource.fetchSkills();
      return ApiResult.success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }
}
