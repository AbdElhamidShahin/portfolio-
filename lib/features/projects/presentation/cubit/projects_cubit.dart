import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/projects_repository.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final ProjectsRepository _repository;

  ProjectsCubit(this._repository) : super(const ProjectsInitial());

  Future<void> loadProjects() async {
    emit(const ProjectsLoading());
    try {
      final projects = await _repository.getProjects();
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }
}
