import '../models/contact_info_model.dart';
import '../models/contact_message_model.dart';

/// Mock-only data source for the Contact feature.
/// Throws raw exceptions on failure — never catches them itself.
/// [ContactRepositoryImpl] owns all error mapping.
class ContactService {
  Future<ContactInfoModel> fetchContactInfo() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const ContactInfoModel(
      email: 'abdelhamid.shahin.dev@gmail.com',
      location: 'Menoufia, Egypt',
      githubUrl: 'https://github.com/AbdelhamidShahin',
      linkedInUrl: 'https://linkedin.com/in/abdelhamid-shahin',
    );
  }

  Future<void> submitMessage(ContactMessageModel message) async {
    // Simulate network latency for a form submission.
    await Future.delayed(const Duration(milliseconds: 1200));
    // Mock-only: in production, replace with an HTTP POST or Supabase insert.
  }
}
