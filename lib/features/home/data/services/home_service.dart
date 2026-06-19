import '../models/home_model.dart';

/// Handles raw data fetching for the Home feature.
/// Mock-only for now — replace with an HTTP/local JSON call later.
/// Throws raw exceptions on failure; never catches them itself.
class HomeService {
  Future<HomeModel> fetchHomeProfile() async {
    // Simulate network/IO latency
    await Future.delayed(const Duration(milliseconds: 600));

    return const HomeModel(
      fullName: 'Your Name',
      headline: 'Flutter & Mobile Engineer',
      tagline: 'I build clean, performant cross-platform apps.',
      avatarUrl: 'assets/images/home/avatar.png',
      socialLinks: [
        'https://github.com/example',
        'https://linkedin.com/in/example',
      ],
    );
  }
}
