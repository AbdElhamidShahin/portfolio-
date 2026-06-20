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
            'Flutter Developer with a strong interest in software architecture and scalable application design. '
            'I build mobile apps using Clean Architecture, SOLID principles, and modern state management approaches '
            'to create maintainable, testable, and user-focused solutions.',
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
          'CI / CD',
          'Flutter Web',
          'Git & GitHub Workflow',
          'Dependency Injection',
          'Authentication & Authorization'
        ],
        highlights: [
          'Published and maintained Flutter applications on Android',
          'Built hotel booking, fitness, and tourism applications using Flutter',
          'Used Clean Architecture and BLoC to keep projects organized and scalable',
          'Worked with Supabase, Firebase, and REST APIs for backend integration',
          'Implemented payment processing and authentication features',
        ]);
  }
}
