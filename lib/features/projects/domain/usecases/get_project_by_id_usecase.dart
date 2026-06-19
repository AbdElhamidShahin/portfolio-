import '../../../../core/error/api_result.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectByIdUseCase {
  final ProjectsRepository _repository;

  const GetProjectByIdUseCase(this._repository);

  Future<ApiResult<ProjectEntity>> call(String id) {
    return _repository.getProjectById(id);
  }
}
