import '../../domain/entities/project_entity.dart';

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
  final List<ProjectEntity> projects;
  const ProjectsLoaded(this.projects);
}

final class ProjectsError extends ProjectsState {
  final String message;
  const ProjectsError(this.message);
}
