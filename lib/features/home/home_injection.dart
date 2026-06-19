import 'data/datasources/home_remote_datasource.dart';
import 'data/repositories/home_repository_impl.dart';
import 'data/services/home_service.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_home_profile_usecase.dart';
import 'presentation/cubit/home_cubit.dart';
import '../../core/di/service_locator.dart' show getIt;

/// Registers every dependency for the Home feature.
/// Called once from core/di/injection_container.dart.
void registerHomeFeature() {
  // Services
  getIt.registerLazySingleton<HomeService>(() => HomeService());

  // DataSources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt<HomeService>()),
  );

  // Repositories
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<GetHomeProfileUseCase>(
    () => GetHomeProfileUseCase(getIt<HomeRepository>()),
  );

  // Cubits — factory, since each page visit should get a fresh instance
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<GetHomeProfileUseCase>()),
  );
}
