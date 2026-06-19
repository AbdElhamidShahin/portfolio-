/// Pure domain entity for contact info shown on the Contact page.
class ContactInfoEntity {
  final String email;
  final String phone;
  final String location;
  final List<String> socialLinks;

  const ContactInfoEntity({
    required this.email,
    required this.phone,
    required this.location,
    required this.socialLinks,
  });
}
