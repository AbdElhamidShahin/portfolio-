import '../models/project_model.dart';

/// Handles raw data fetching for projects.
/// Replace the hardcoded list with an API/local JSON call later.
class ProjectsService {
  Future<List<ProjectModel>> fetchProjects() async {
    // Simulate network/IO latency
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      ProjectModel(
        id: 'p1',
        title: 'Portfolio Website',
        description:
            'A premium dark-themed personal portfolio built with Flutter Web.',
        imageUrl: 'assets/images/projects/portfolio.png',
        techStack: ['Flutter', 'Dart', 'Cubit'],
        liveUrl: 'https://example.com',
        repoUrl: 'https://github.com/example/portfolio',
      ),
      ProjectModel(
        id: 'p2',
        title: 'E-Commerce App',
        description:
            'A cross-platform shopping app with real-time inventory.',
        imageUrl: 'assets/images/projects/ecommerce.png',
        techStack: ['Flutter', 'Firebase', 'GetIt'],
        repoUrl: 'https://github.com/example/ecommerce',
      ),
      ProjectModel(
        id: 'p3',
        title: 'Task Manager',
        description: 'A productivity tool with offline-first sync.',
        imageUrl: 'assets/images/projects/task_manager.png',
        techStack: ['Flutter', 'Hive', 'Cubit'],
        liveUrl: 'https://example.com/tasks',
      ),
    ];

    // Future local JSON example:
    // final raw = await rootBundle.loadString('assets/data/projects.json');
    // final List<dynamic> data = jsonDecode(raw);
    // return data.map((e) => ProjectModel.fromJson(e)).toList();
  }
}
