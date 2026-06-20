/// Pure domain entity representing a message submitted via the contact form.
class ContactMessageEntity {
  final String name;
  final String email;
  final String subject;
  final String message;

  const ContactMessageEntity({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });
}
