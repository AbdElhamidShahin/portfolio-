import '../models/home_model.dart';

/// Handles raw data fetching for the Home feature.
/// Mock-only for now — replace with an HTTP/local JSON call later.
/// Throws raw exceptions on failure; never catches them itself.
class HomeService {
  Future<HomeModel> fetchHomeProfile() async {
    // Simulate network/IO latency
    await Future.delayed(const Duration(milliseconds: 600));

    return const HomeModel(
      fullName: 'Abdelhamid Shahin',
      headline: 'Junior Flutter Developer',
      tagline:
          'I engineer clean, scalable mobile and web apps with Flutter — '
          'built on Clean Architecture, tuned for performance, and designed '
          'to grow without breaking.',
      avatarUrl: 'assets/images/home/avatar.png',
      socialLinks: [
        'https://github.com/example',
        'https://linkedin.com/in/example',
      ],
    );
  }
}
