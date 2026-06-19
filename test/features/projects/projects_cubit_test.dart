import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/error/api_result.dart';
import 'package:portfolio/core/error/failure.dart';
import 'package:portfolio/features/projects/logic/entities/project_entity.dart';
import 'package:portfolio/features/projects/logic/repositories/projects_repository.dart';
import 'package:portfolio/features/projects/logic/usecases/get_projects_usecase.dart';
import 'package:portfolio/features/projects/ui/cubit/projects_cubit.dart';
import 'package:portfolio/features/projects/ui/cubit/projects_state.dart';

/// Fake repository — demonstrates that testing the Cubit requires only
/// implementing the logic's abstract ProjectsRepository, with zero
/// knowledge of HTTP, JSON, or any data-layer detail.
class _FakeProjectsRepository implements ProjectsRepository {
  final ApiResult<List<ProjectEntity>> result;
  const _FakeProjectsRepository(this.result);

  @override
  Future<ApiResult<List<ProjectEntity>>> getProjects() async => result;

  @override
  Future<ApiResult<ProjectEntity>> getProjectById(String id) async {
    throw UnimplementedError();
  }
}

void main() {
  const sampleProjects = [
    ProjectEntity(
      id: '1',
      title: 'Portfolio Site',
      description: 'A Flutter Web portfolio built with Clean Architecture.',
      techStack: ['Flutter', 'Cubit', 'GetIt'],
      thumbnailUrl: '',
    ),
  ];

  group('ProjectsCubit', () {
    blocTest<ProjectsCubit, ProjectsState>(
      'emits [Loading, Loaded] when usecase succeeds',
      build: () => ProjectsCubit(
        GetProjectsUseCase(
          const _FakeProjectsRepository(ApiResult.success(sampleProjects)),
        ),
      ),
      act: (cubit) => cubit.loadProjects(),
      expect: () => [
        const ProjectsLoading(),
        const ProjectsLoaded(sampleProjects),
      ],
    );

    blocTest<ProjectsCubit, ProjectsState>(
      'emits [Loading, Error] when usecase fails',
      build: () => ProjectsCubit(
        GetProjectsUseCase(
          const _FakeProjectsRepository(
            ApiResult.failure(NetworkFailure()),
          ),
        ),
      ),
      act: (cubit) => cubit.loadProjects(),
      expect: () => [
        const ProjectsLoading(),
        isA<ProjectsError>(),
      ],
    );
  });
}
