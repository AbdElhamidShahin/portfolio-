/// Pure domain entity for the Home/hero section. No Flutter imports,
/// no JSON — just the business shape the UI is allowed to depend on.
class HomeEntity {
  final String fullName;
  final String headline;
  final String tagline;
  final String avatarUrl;
  final List<String> socialLinks;

  const HomeEntity({
    required this.fullName,
    required this.headline,
    required this.tagline,
    required this.avatarUrl,
    required this.socialLinks,
  });
}
