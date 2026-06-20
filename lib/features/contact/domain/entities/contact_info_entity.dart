/// Pure domain entity for the contact info displayed on the Contact section.
/// No Flutter imports — framework-agnostic by design.
class ContactInfoEntity {
  final String email;
  final String location;
  final String githubUrl;
  final String linkedInUrl;

  const ContactInfoEntity({
    required this.email,
    required this.location,
    required this.githubUrl,
    required this.linkedInUrl,
  });
}
