import '../../domain/entities/project_entity.dart';

/// Data-layer shape for a single project. JSON-aware; domain layer is not.
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String thumbnailUrl;
  final String? liveUrl;
  final String? repoUrl;
  final String? githubUrl;
  final String? googlePlayUrl;

  const ProjectModel({
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

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      techStack: (json['techStack'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      thumbnailUrl: json['thumbnailUrl'] as String,
      liveUrl: json['liveUrl'] as String?,
      repoUrl: json['repoUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      googlePlayUrl: json['googlePlayUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'techStack': techStack,
      'thumbnailUrl': thumbnailUrl,
      'liveUrl': liveUrl,
      'repoUrl': repoUrl,
      'githubUrl': githubUrl,
      'googlePlayUrl': googlePlayUrl,
    };
  }

  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      title: title,
      description: description,
      techStack: techStack,
      thumbnailUrl: thumbnailUrl,
      liveUrl: liveUrl,
      repoUrl: repoUrl,
      githubUrl: githubUrl,
      googlePlayUrl: googlePlayUrl,
    );
  }
}
