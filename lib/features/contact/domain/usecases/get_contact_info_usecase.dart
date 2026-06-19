import '../../../../core/error/api_result.dart';
import '../entities/contact_info_entity.dart';
import '../repositories/contact_repository.dart';

class GetContactInfoUseCase {
  final ContactRepository _repository;

  const GetContactInfoUseCase(this._repository);

  Future<ApiResult<ContactInfoEntity>> call() {
    return _repository.getContactInfo();
  }
}
