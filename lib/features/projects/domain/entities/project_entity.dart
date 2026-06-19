/// Pure domain entity for a single portfolio project.
class ProjectEntity {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String thumbnailUrl;
  final String? liveUrl;
  final String? repoUrl;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.thumbnailUrl,
    this.liveUrl,
    this.repoUrl,
  });
}
