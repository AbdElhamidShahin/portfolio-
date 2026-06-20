/// Value object describing the developer's education. Pure Dart — no Flutter.
class EducationEntity {
  final String degree;
  final String institution;
  final String graduationDate;
  final String fieldOfStudy;

  const EducationEntity({
    required this.degree,
    required this.institution,
    required this.graduationDate,
    required this.fieldOfStudy,
  });
}

/// Pure domain entity for the About section.
/// No Flutter imports, no JSON awareness — only the shape the UI may depend on.
class AboutEntity {
  final String bio;
  final String location;
  final String availability;
  final EducationEntity education;
  final List<String> focusAreas;
  final List<String> highlights;

  const AboutEntity({
    required this.bio,
    required this.location,
    required this.availability,
    required this.education,
    required this.focusAreas,
    required this.highlights,
  });
}
