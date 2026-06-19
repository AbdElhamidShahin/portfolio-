import '../../../../core/error/api_result.dart';
import '../entities/about_entity.dart';
import '../repositories/about_repository.dart';

class GetAboutUseCase {
  final AboutRepository _repository;

  const GetAboutUseCase(this._repository);

  Future<ApiResult<AboutEntity>> call() {
    return _repository.getAbout();
  }
}
