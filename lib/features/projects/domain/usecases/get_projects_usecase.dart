import '../../../../core/error/api_result.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase {
  final ProjectsRepository _repository;

  const GetProjectsUseCase(this._repository);

  Future<ApiResult<List<ProjectEntity>>> call() {
    return _repository.getProjects();
  }
}
