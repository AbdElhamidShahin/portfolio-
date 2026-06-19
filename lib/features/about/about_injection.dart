import '../../core/di/service_locator.dart' show getIt;
import 'data/datasources/about_remote_datasource.dart';
import 'data/repositories/about_repository_impl.dart';
import 'data/services/about_service.dart';
import 'domain/repositories/about_repository.dart';
import 'domain/usecases/get_about_usecase.dart';
import 'presentation/cubit/about_cubit.dart';

/// Registers every dependency for the About feature.
/// Called once from core/di/injection_container.dart.
void registerAboutFeature() {
  // Services
  getIt.registerLazySingleton<AboutService>(() => AboutService());

  // DataSources
  getIt.registerLazySingleton<AboutRemoteDataSource>(
    () => AboutRemoteDataSourceImpl(getIt<AboutService>()),
  );

  // Repositories
  getIt.registerLazySingleton<AboutRepository>(
    () => AboutRepositoryImpl(getIt<AboutRemoteDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<GetAboutUseCase>(
    () => GetAboutUseCase(getIt<AboutRepository>()),
  );

  // Cubits — factory, since each page visit should get a fresh instance
  getIt.registerFactory<AboutCubit>(
    () => AboutCubit(getIt<GetAboutUseCase>()),
  );
}
