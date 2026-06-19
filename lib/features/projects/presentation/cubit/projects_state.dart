import '../../data/models/project_model.dart';

sealed class ProjectsState {
  const ProjectsState();
}

final class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

final class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

final class ProjectsLoaded extends ProjectsState {
  final List<ProjectModel> projects;
  const ProjectsLoaded(this.projects);
}

final class ProjectsError extends ProjectsState {
  final String message;
  const ProjectsError(this.message);
}
