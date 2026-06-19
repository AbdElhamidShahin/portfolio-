import '../../../../core/error/api_result.dart';
import '../entities/contact_message_entity.dart';
import '../repositories/contact_repository.dart';

class SendContactMessageUseCase {
  final ContactRepository _repository;

  const SendContactMessageUseCase(this._repository);

  Future<ApiResult<void>> call(ContactMessageEntity message) {
    return _repository.sendMessage(message);
  }
}
