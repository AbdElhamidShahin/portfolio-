import '../../../../core/error/api_result.dart';
import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<ApiResult<List<ProjectEntity>>> getProjects();
  Future<ApiResult<ProjectEntity>> getProjectById(String id);
}
