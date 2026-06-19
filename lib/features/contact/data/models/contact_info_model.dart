import '../../domain/entities/contact_info_entity.dart';

class ContactInfoModel {
  final String email;
  final String phone;
  final String location;
  final List<String> socialLinks;

  const ContactInfoModel({
    required this.email,
    required this.phone,
    required this.location,
    required this.socialLinks,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      socialLinks: (json['socialLinks'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'location': location,
      'socialLinks': socialLinks,
    };
  }

  ContactInfoEntity toEntity() {
    return ContactInfoEntity(
      email: email,
      phone: phone,
      location: location,
      socialLinks: socialLinks,
    );
  }
}
