import '../../core/di/service_locator.dart' show getIt;
import 'data/datasources/projects_remote_datasource.dart';
import 'data/repositories/projects_repository_impl.dart';
import 'data/services/projects_service.dart';
import 'domain/repositories/projects_repository.dart';
import 'domain/usecases/get_project_by_id_usecase.dart';
import 'domain/usecases/get_projects_usecase.dart';
import 'presentation/cubit/projects_cubit.dart';

/// Registers every dependency for the Projects feature.
/// Called once from core/di/injection_container.dart.
void registerProjectsFeature() {
  // Services
  getIt.registerLazySingleton<ProjectsService>(() => ProjectsService());

  // DataSources
  getIt.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(getIt<ProjectsService>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(getIt<ProjectsRemoteDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<GetProjectsUseCase>(
    () => GetProjectsUseCase(getIt<ProjectsRepository>()),
  );
  getIt.registerLazySingleton<GetProjectByIdUseCase>(
    () => GetProjectByIdUseCase(getIt<ProjectsRepository>()),
  );

  // Cubits — factory, since each page visit should get a fresh instance
  getIt.registerFactory<ProjectsCubit>(
    () => ProjectsCubit(getIt<GetProjectsUseCase>()),
  );
}
