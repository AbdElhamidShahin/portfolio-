/// Pure domain entity for contact info shown on the Contact page.
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
