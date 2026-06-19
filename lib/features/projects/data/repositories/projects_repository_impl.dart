import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_remote_datasource.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource _dataSource;

  const ProjectsRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<List<ProjectEntity>>> getProjects() async {
    try {
      final models = await _dataSource.fetchProjects();
      return ApiResult.success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<ProjectEntity>> getProjectById(String id) async {
    try {
      final model = await _dataSource.fetchProjectById(id);
      return ApiResult.success(model.toEntity());
    } catch (e) {
      return ApiResult.failure(NotFoundFailure(e.toString()));
    }
  }
}
