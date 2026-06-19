import '../../../../core/error/api_result.dart';
import '../entities/contact_info_entity.dart';
import '../entities/contact_message_entity.dart';

abstract class ContactRepository {
  Future<ApiResult<ContactInfoEntity>> getContactInfo();
  Future<ApiResult<void>> sendMessage(ContactMessageEntity message);
}
