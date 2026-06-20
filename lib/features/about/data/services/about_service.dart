import '../models/about_model.dart';

/// Mock-only data source for the About feature.
/// Throws raw exceptions on failure — never catches them itself.
/// [AboutRepositoryImpl] owns all error mapping.
class AboutService {
  Future<AboutModel> fetchAbout() async {
    // Simulate network / IO latency
    await Future.delayed(const Duration(milliseconds: 600));

    return const AboutModel(
      bio:
          'I\'m a Flutter developer who obsesses over clean, maintainable '
          'code. I treat every app as a system — built in layers, where '
          'business logic is isolated, testable, and completely independent '
          'of whatever framework or UI is sitting on top of it. '
          'Clean Architecture and SOLID principles aren\'t just words I\'ve '
          'read; they\'re the lens I use every time I open a new file.',
      location: 'Menoufia, Egypt',
      availability: 'Open to opportunities',
      education: EducationModel(
        degree: 'Bachelor\'s Degree in Information Systems',
        institution: 'Higher Institute for Computers and Information – Tanta',
        graduationDate: 'June 2026',
        fieldOfStudy: 'Information Systems',
      ),
      focusAreas: [
        'Clean Architecture',
        'SOLID Principles',
        'Cubit / BLoC',
        'Supabase',
        'Firebase',
        'Stripe Integration',
        'REST APIs',
        'State Management',
        'UI / UX',
        'Flutter Web',
      ],
      highlights: [
        'Built end-to-end Flutter apps for mobile and web from a single codebase',
        'Applied Clean Architecture with strict layer separation on every project',
        'Integrated Supabase and Firebase for auth, real-time data, and storage',
        'Implemented Stripe payment flows in production mobile applications',
        'Maintained zero Flutter imports inside domain layers across all features',
      ],
    );
  }
}
