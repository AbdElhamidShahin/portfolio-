import 'package:get_it/get_it.dart';

import '../../features/projects/data/repositories/projects_repository.dart';
import '../../features/projects/data/services/projects_service.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<ProjectsService>(() => ProjectsService());

  // Repositories
  getIt.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepository(getIt<ProjectsService>()),
  );

  // Cubits — factory, since each page visit should get a fresh instance
  getIt.registerFactory<ProjectsCubit>(
    () => ProjectsCubit(getIt<ProjectsRepository>()),
  );
}
