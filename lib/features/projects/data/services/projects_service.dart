import '../models/project_model.dart';

/// Mock-only data fetching for the Projects feature.
/// Throws raw exceptions on failure; never catches them itself —
/// ProjectsRepositoryImpl owns all error mapping.
class ProjectsService {
  Future<List<ProjectModel>> fetchProjects() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      ProjectModel(
        id: 'p1',
        title: 'Voyage — Hotel Booking App',
        description:
            'A cross-platform hotel discovery and booking experience with '
            'live availability, secure checkout, and an itinerary manager. '
            'Built for speed on both iOS and Android from a single codebase.',
        techStack: ['Flutter', 'Cubit', 'Stripe', 'Google Maps'],
        thumbnailUrl:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1200&auto=format&fit=crop',
        liveUrl: 'https://example.com/voyage',
        githubUrl: 'https://github.com/AbdelhamidShahin/voyage-booking',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.example.voyage',
      ),
      ProjectModel(
        id: 'p2',
        title: 'Pulse — Fitness Tracking App',
        description:
            'A workout and health-tracking companion with adaptive training '
            'plans, wearable sync, and real-time progress charts that keep '
            'users motivated session after session.',
        techStack: ['Flutter', 'HealthKit', 'Firebase', 'Cubit'],
        thumbnailUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=1200&auto=format&fit=crop',
        githubUrl: 'https://github.com/AbdelhamidShahin/pulse-fitness',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.example.pulse',
      ),
      ProjectModel(
        id: 'p3',
        title: 'CivicLink — City Services Directory',
        description:
            'A unified directory connecting residents to municipal services, '
            'permits, and local announcements, with offline-first access for '
            'low-connectivity areas and full accessibility support.',
        techStack: ['Flutter', 'GetIt', 'REST API', 'Hive'],
        thumbnailUrl:
            'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?q=80&w=1200&auto=format&fit=crop',
        githubUrl: 'https://github.com/AbdelhamidShahin/civiclink',
      ),
      ProjectModel(
        id: 'p4',
        title: 'Larder — Recipe & Pantry Planner',
        description:
            'A meal-planning app that turns pantry inventory into recipe '
            'suggestions, generates shopping lists, and reduces household '
            'food waste through smart expiry tracking.',
        techStack: ['Flutter', 'SQLite', 'Cubit'],
        thumbnailUrl:
            'https://images.unsplash.com/photo-1556909212-d5b65c0f2e6e?q=80&w=1200&auto=format&fit=crop',
        githubUrl: 'https://github.com/AbdelhamidShahin/larder',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.example.larder',
      ),
      ProjectModel(
        id: 'p5',
        title: 'Ledger — Personal Finance Tracker',
        description:
            'A privacy-first budgeting app with automatic categorization, '
            'multi-currency support, and visual spending insights — all '
            'computed on-device with no data leaving the user\'s phone.',
        techStack: ['Flutter', 'Drift', 'Cubit', 'fl_chart'],
        thumbnailUrl:
            'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?q=80&w=1200&auto=format&fit=crop',
        githubUrl: 'https://github.com/AbdelhamidShahin/ledger-finance',
      ),
      ProjectModel(
        id: 'p6',
        title: 'Wanderlist — Travel Itinerary Planner',
        description:
            'A collaborative trip planner letting groups build shared '
            'itineraries, split expenses, and sync changes in real time '
            'across every traveler\'s device.',
        techStack: ['Flutter', 'Firebase', 'GetIt', 'Google Maps'],
        thumbnailUrl:
            'https://images.unsplash.com/photo-1488646953014-85cb44e25828?q=80&w=1200&auto=format&fit=crop',
        githubUrl: 'https://github.com/AbdelhamidShahin/wanderlist',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.example.wanderlist',
      ),
    ];
  }

  Future<ProjectModel> fetchProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final projects = await fetchProjects();
    return projects.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Project with id "$id" not found.'),
    );
  }
}
