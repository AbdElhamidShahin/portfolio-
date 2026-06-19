import '../models/project_model.dart';
import '../services/projects_service.dart';

/// Direct repository — no interface/abstraction layer.
/// Acts as a thin pass-through to the service, with room for
/// caching, mapping, or combining multiple sources later.
class ProjectsRepository {
  final ProjectsService _service;

  ProjectsRepository(this._service);

  Future<List<ProjectModel>> getProjects() {
    return _service.fetchProjects();
  }
}
