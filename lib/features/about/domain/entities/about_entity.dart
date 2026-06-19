/// Pure domain entity for the About/bio section.
class AboutEntity {
  final String bio;
  final String location;
  final String yearsOfExperience;
  final List<String> highlights;

  const AboutEntity({
    required this.bio,
    required this.location,
    required this.yearsOfExperience,
    required this.highlights,
  });
}
