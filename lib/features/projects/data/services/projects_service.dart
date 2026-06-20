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
        title: 'Aqua — Hotel Guide (Graduation Project)',
        description:
            'A production-ready hotel discovery and reservation platform built using professional architectural standards. '
            'It features seamless room browsing, robust booking lifecycle management, secure Stripe payment gateway integration, '
            'and real-time data synchronization backed by Supabase.',
        techStack: [
          'Flutter',
          'Dart',
          'Clean Architecture',
          'BLoC / Cubit',
          'Supabase',
          'Stripe',
        ],
        thumbnailUrl: 'assets/images/image1.jpeg',
        repoUrl: 'https://github.com/AbdElhamidShahin/Hotel-Guide',
      ),
      ProjectModel(
        id: 'p2',
        title: 'Power Pulse — Fitness & Nutrition Tracker',
        description:
            'A complete fitness and nutrition companion for tracking workouts, calories, '
            'and BMI. Features real-time food and exercise data via external APIs, smooth '
            'custom animations, and secure cloud synchronization.',
        techStack: [
          'Flutter',
          'Dart',
          'BLoC',
          'MVVM',
          'Firebase',
          'Dio',
          'REST API'
        ],
        thumbnailUrl:
            'assets/images/Purple Pink Gradient Mobile Application Presentation-page-001.jpg',
        repoUrl: 'https://github.com/AbdElhamidShahin/power-pulse-fitness-app',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.yourcompanyname.yourappname&hl=ar', // ملحوظة: يمكنك استبدال الـ ID هنا بـ Package Name الحقيقي الخاص بك على الـ Store إذا كان مختلفاً
      ),
      ProjectModel(
        id: 'p5',
        title: 'Dalily — City Services Locator',
        description:
            'A location-based directory application that helps users easily discover '
            'nearby city services such as pharmacies, clinics, restaurants, and repair centers. '
            'It features a dual-system allowing merchants to list their services, '
            'which appear instantly across the app once reviewed and approved by the admin panel.',
        techStack: [
          'Flutter',
          'Dart',
          'Cubit',
          'MVVM',
          'Firebase Auth',
          'Supabase Storage',
          'Location Services'
        ],
        thumbnailUrl: 'assets/images/707shots_so.png',
        repoUrl: 'https://github.com/AbdElhamidShahin/daliliy-tourism-guide',
      ),
      ProjectModel(
        id: 'p6',
        title: 'Quran Karim — قرآننا',
        description:
            'An offline-first Islamic application featuring the complete Holy Quran '
            'with last-read tracking, quick surah search, an electronic Misbaha, and daily Azkar. '
            'It provides GPS-based prayer times according to the user\'s location, supporting both dark and light modes.',
        techStack: [
          'Flutter',
          'Dart',
          'Cubit',
          'MVVM',
          'SQLite',
          'Location Services',
        ],
        thumbnailUrl: 'assets/images/Screenshot 2025-05-01 143703.png',
        repoUrl: 'https://github.com/AbdElhamidShahin/quran-karim-flutter-app',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.abdo.quranapp&hl=ar',
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
