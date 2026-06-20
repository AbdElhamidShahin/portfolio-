import '../../domain/entities/contact_info_entity.dart';

class ContactInfoModel {
  final String email;
  final String location;
  final String githubUrl;
  final String linkedInUrl;

  const ContactInfoModel({
    required this.email,
    required this.location,
    required this.githubUrl,
    required this.linkedInUrl,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'] as String,
      location: json['location'] as String,
      githubUrl: json['githubUrl'] as String,
      linkedInUrl: json['linkedInUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'location': location,
      'githubUrl': githubUrl,
      'linkedInUrl': linkedInUrl,
    };
  }

  ContactInfoEntity toEntity() {
    return ContactInfoEntity(
      email: email,
      location: location,
      githubUrl: githubUrl,
      linkedInUrl: linkedInUrl,
    );
  }
}
