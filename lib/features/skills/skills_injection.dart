import '../../core/di/service_locator.dart' show getIt;
import 'data/datasources/skills_remote_datasource.dart';
import 'data/repositories/skills_repository_impl.dart';
import 'data/services/skills_service.dart';
import 'domain/repositories/skills_repository.dart';
import 'domain/usecases/get_skills_usecase.dart';
import 'presentation/cubit/skills_cubit.dart';

/// Registers every dependency for the Skills feature.
/// Called once from core/di/injection_container.dart.
void registerSkillsFeature() {
  // Services
  getIt.registerLazySingleton<SkillsService>(() => SkillsService());

  // DataSources
  getIt.registerLazySingleton<SkillsRemoteDataSource>(
    () => SkillsRemoteDataSourceImpl(getIt<SkillsService>()),
  );

  // Repositories
  getIt.registerLazySingleton<SkillsRepository>(
    () => SkillsRepositoryImpl(getIt<SkillsRemoteDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<GetSkillsUseCase>(
    () => GetSkillsUseCase(getIt<SkillsRepository>()),
  );

  // Cubits — factory, since each page visit should get a fresh instance
  getIt.registerFactory<SkillsCubit>(
    () => SkillsCubit(getIt<GetSkillsUseCase>()),
  );
}
