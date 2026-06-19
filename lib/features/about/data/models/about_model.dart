import '../../domain/entities/about_entity.dart';

class AboutModel {
  final String bio;
  final String location;
  final String yearsOfExperience;
  final List<String> highlights;

  const AboutModel({
    required this.bio,
    required this.location,
    required this.yearsOfExperience,
    required this.highlights,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      bio: json['bio'] as String,
      location: json['location'] as String,
      yearsOfExperience: json['yearsOfExperience'] as String,
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'location': location,
      'yearsOfExperience': yearsOfExperience,
      'highlights': highlights,
    };
  }

  AboutEntity toEntity() {
    return AboutEntity(
      bio: bio,
      location: location,
      yearsOfExperience: yearsOfExperience,
      highlights: highlights,
    );
  }
}
