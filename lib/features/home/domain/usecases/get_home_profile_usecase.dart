import '../../../../core/error/api_result.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Fetches the Home/hero profile data.
/// Cubit depends on this and never touches HomeRepository directly.
class GetHomeProfileUseCase {
  final HomeRepository _repository;

  const GetHomeProfileUseCase(this._repository);

  Future<ApiResult<HomeEntity>> call() {
    return _repository.getHomeProfile();
  }
}
