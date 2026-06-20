import '../models/contact_info_model.dart';
import '../models/contact_message_model.dart';

/// Mock-only data fetching/sending for the Contact feature.
/// Throws raw exceptions on failure; never catches them itself.
class ContactService {
  Future<ContactInfoModel> fetchContactInfo() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const ContactInfoModel(
      email: 'contact@yourdomain.dev',
      location: 'Menoufia, Egypt',
      githubUrl: 'https://github.com/yourusername',
      linkedInUrl: 'https://linkedin.com/in/yourusername',
    );
  }

  Future<void> submitMessage(ContactMessageModel message) async {
    // Simulate network/IO latency for a form submission.
    await Future.delayed(const Duration(milliseconds: 900));
    // Mock-only: no real request is made.
  }
}
