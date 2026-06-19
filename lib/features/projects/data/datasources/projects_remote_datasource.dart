import '../models/project_model.dart';
import '../services/projects_service.dart';

abstract class ProjectsRemoteDataSource {
  Future<List<ProjectModel>> fetchProjects();
  Future<ProjectModel> fetchProjectById(String id);
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final ProjectsService _service;

  const ProjectsRemoteDataSourceImpl(this._service);

  @override
  Future<List<ProjectModel>> fetchProjects() {
    return _service.fetchProjects();
  }

  @override
  Future<ProjectModel> fetchProjectById(String id) {
    return _service.fetchProjectById(id);
  }
}
