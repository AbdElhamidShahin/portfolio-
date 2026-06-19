import '../models/project_model.dart';

/// Mock-only data fetching for the Projects feature.
/// Throws raw exceptions on failure; never catches them itself.
class ProjectsService {
  Future<List<ProjectModel>> fetchProjects() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      ProjectModel(
        id: 'p1',
        title: 'Portfolio Website',
        description:
            'A premium dark-themed personal portfolio built with Flutter Web.',
        techStack: ['Flutter', 'Dart', 'Cubit'],
        thumbnailUrl: 'assets/images/projects/portfolio.png',
        liveUrl: 'https://example.com',
        repoUrl: 'https://github.com/example/portfolio',
      ),
      ProjectModel(
        id: 'p2',
        title: 'E-Commerce App',
        description:
            'A cross-platform shopping app with real-time inventory.',
        techStack: ['Flutter', 'Firebase', 'GetIt'],
        thumbnailUrl: 'assets/images/projects/ecommerce.png',
        repoUrl: 'https://github.com/example/ecommerce',
      ),
      ProjectModel(
        id: 'p3',
        title: 'Task Manager',
        description: 'A productivity tool with offline-first sync.',
        techStack: ['Flutter', 'Hive', 'Cubit'],
        thumbnailUrl: 'assets/images/projects/task_manager.png',
        liveUrl: 'https://example.com/tasks',
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
