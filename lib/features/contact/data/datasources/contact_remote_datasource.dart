import '../models/contact_info_model.dart';
import '../models/contact_message_model.dart';
import '../services/contact_service.dart';

abstract class ContactRemoteDataSource {
  Future<ContactInfoModel> fetchContactInfo();
  Future<void> submitMessage(ContactMessageModel message);
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final ContactService _service;

  const ContactRemoteDataSourceImpl(this._service);

  @override
  Future<ContactInfoModel> fetchContactInfo() {
    return _service.fetchContactInfo();
  }

  @override
  Future<void> submitMessage(ContactMessageModel message) {
    return _service.submitMessage(message);
  }
}
