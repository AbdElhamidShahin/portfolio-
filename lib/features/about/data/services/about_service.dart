import '../models/about_model.dart';

/// Mock-only data fetching for the About feature.
/// Throws raw exceptions on failure; never catches them itself.
class AboutService {
  Future<AboutModel> fetchAbout() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const AboutModel(
      bio:
          'A short biography describing background, interests, and '
          'professional journey goes here.',
      location: 'Cairo, Egypt',
      yearsOfExperience: '3+ years',
      highlights: [
        'Cross-platform Flutter development',
        'Clean Architecture advocate',
        'Open-source contributor',
      ],
    );
  }
}
