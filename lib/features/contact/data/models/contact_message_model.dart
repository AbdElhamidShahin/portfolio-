import '../../domain/entities/contact_message_entity.dart';

class ContactMessageModel {
  final String name;
  final String email;
  final String subject;
  final String message;

  const ContactMessageModel({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  factory ContactMessageModel.fromEntity(ContactMessageEntity entity) {
    return ContactMessageModel(
      name: entity.name,
      email: entity.email,
      subject: entity.subject,
      message: entity.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };
  }
}
