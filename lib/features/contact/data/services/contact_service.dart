import '../models/contact_info_model.dart';
import '../models/contact_message_model.dart';

class ContactService {
  Future<ContactInfoModel> fetchContactInfo() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const ContactInfoModel(
      email: 'abdelhamid.shahin0@gmail.com',
      location: 'Menoufia, Egypt',
      githubUrl: 'https://github.com/AbdElhamidShahin',
      linkedInUrl: 'https://www.linkedin.com/in/abd-el-hamid-shahin-7a035b268/',
    );
  }

  Future<void> submitMessage(ContactMessageModel message) async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }
}
