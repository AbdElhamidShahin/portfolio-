import '../../domain/entities/about_entity.dart';

/// Data-layer value object for education. Knows about JSON; domain never does.
class EducationModel {
  final String degree;
  final String institution;
  final String graduationDate;
  final String fieldOfStudy;

  const EducationModel({
    required this.degree,
    required this.institution,
    required this.graduationDate,
    required this.fieldOfStudy,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      graduationDate: json['graduationDate'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'graduationDate': graduationDate,
      'fieldOfStudy': fieldOfStudy,
    };
  }

  EducationEntity toEntity() {
    return EducationEntity(
      degree: degree,
      institution: institution,
      graduationDate: graduationDate,
      fieldOfStudy: fieldOfStudy,
    );
  }
}

/// Data-layer shape for the About section. Knows about JSON; the domain layer
/// never does. All exceptions are thrown raw — the repository impl catches them.
class AboutModel {
  final String bio;
  final String location;
  final String availability;
  final EducationModel education;
  final List<String> focusAreas;
  final List<String> highlights;

  const AboutModel({
    required this.bio,
    required this.location,
    required this.availability,
    required this.education,
    required this.focusAreas,
    required this.highlights,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      bio: json['bio'] as String,
      location: json['location'] as String,
      availability: json['availability'] as String,
      education: EducationModel.fromJson(
        json['education'] as Map<String, dynamic>,
      ),
      focusAreas: (json['focusAreas'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'location': location,
      'availability': availability,
      'education': education.toJson(),
      'focusAreas': focusAreas,
      'highlights': highlights,
    };
  }

  AboutEntity toEntity() {
    return AboutEntity(
      bio: bio,
      location: location,
      availability: availability,
      education: education.toEntity(),
      focusAreas: focusAreas,
      highlights: highlights,
    );
  }
}
