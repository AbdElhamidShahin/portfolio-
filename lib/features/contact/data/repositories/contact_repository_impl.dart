import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../../domain/entities/contact_message_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_remote_datasource.dart';
import '../models/contact_message_model.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource _dataSource;

  const ContactRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<ContactInfoEntity>> getContactInfo() async {
    try {
      final model = await _dataSource.fetchContactInfo();
      return ApiResult.success(model.toEntity());
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> sendMessage(ContactMessageEntity message) async {
    try {
      await _dataSource.submitMessage(
        ContactMessageModel.fromEntity(message),
      );
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }
}
