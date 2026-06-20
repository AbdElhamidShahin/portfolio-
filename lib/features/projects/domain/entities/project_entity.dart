/// Pure domain entity for a single portfolio project. No Flutter imports.
class ProjectEntity {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String thumbnailUrl;
  final String? liveUrl;
  final String? repoUrl;

  /// Direct link to the GitHub repository (shown as GitHub icon button).
  /// Null hides the button entirely — never shown as disabled.
  final String? githubUrl;

  /// Direct link to the Google Play listing (shown as Play Store icon button).
  /// Null hides the button entirely — never shown as disabled.
  final String? googlePlayUrl;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.thumbnailUrl,
    this.liveUrl,
    this.repoUrl,
    this.githubUrl,
    this.googlePlayUrl,
  });
}
