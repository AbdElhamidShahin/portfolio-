import '../../domain/entities/project_entity.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String thumbnailUrl;
  final String? liveUrl;
  final String? repoUrl;
  final String? playStoreUrl;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.thumbnailUrl,
    this.liveUrl,
    this.repoUrl,
    this.playStoreUrl,
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
      playStoreUrl: json['playStoreUrl'] as String?,
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
      'playStoreUrl': playStoreUrl,
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
      playStoreUrl: playStoreUrl,
    );
  }
}
