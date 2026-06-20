/// Pure domain entity for the Home/hero section. No Flutter imports,
/// no JSON — just the business shape the UI is allowed to depend on.
class HomeEntity {
  final String fullName;
  final String headline;
  final String tagline;
  final String avatarUrl;

  /// Asset path to the CV PDF (e.g. 'assets/cv/abdelhamid_shahin_cv.pdf').
  /// Used by the Download CV button in the hero CTA row.
  final String cvAssetPath;

  /// Quick-contact links rendered as icon buttons below the CTA row.
  final String whatsappUrl;
  final String githubUrl;
  final String linkedInUrl;
  final String gmailUrl; // mailto: link

  const HomeEntity({
    required this.fullName,
    required this.headline,
    required this.tagline,
    required this.avatarUrl,
    required this.cvAssetPath,
    required this.whatsappUrl,
    required this.githubUrl,
    required this.linkedInUrl,
    required this.gmailUrl,
  });
}
