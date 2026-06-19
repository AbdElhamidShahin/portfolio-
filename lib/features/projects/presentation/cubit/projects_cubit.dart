import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_projects_usecase.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final GetProjectsUseCase _getProjectsUseCase;

  ProjectsCubit(this._getProjectsUseCase) : super(const ProjectsInitial());

  Future<void> loadProjects() async {
    emit(const ProjectsLoading());
    final result = await _getProjectsUseCase();
    result.when(
      success: (projects) => emit(ProjectsLoaded(projects)),
      failure: (failure) => emit(ProjectsError(failure.message)),
    );
  }
}
