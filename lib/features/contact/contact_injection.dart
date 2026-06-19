import '../../core/di/service_locator.dart' show getIt;
import 'data/datasources/contact_remote_datasource.dart';
import 'data/repositories/contact_repository_impl.dart';
import 'data/services/contact_service.dart';
import 'domain/repositories/contact_repository.dart';
import 'domain/usecases/get_contact_info_usecase.dart';
import 'domain/usecases/send_contact_message_usecase.dart';
import 'presentation/cubit/contact_cubit.dart';

/// Registers every dependency for the Contact feature.
/// Called once from core/di/injection_container.dart.
void registerContactFeature() {
  // Services
  getIt.registerLazySingleton<ContactService>(() => ContactService());

  // DataSources
  getIt.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(getIt<ContactService>()),
  );

  // Repositories
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(getIt<ContactRemoteDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<GetContactInfoUseCase>(
    () => GetContactInfoUseCase(getIt<ContactRepository>()),
  );
  getIt.registerLazySingleton<SendContactMessageUseCase>(
    () => SendContactMessageUseCase(getIt<ContactRepository>()),
  );

  // Cubits — factory, since each page visit should get a fresh instance
  getIt.registerFactory<ContactCubit>(
    () => ContactCubit(
      getIt<GetContactInfoUseCase>(),
      getIt<SendContactMessageUseCase>(),
    ),
  );
}
