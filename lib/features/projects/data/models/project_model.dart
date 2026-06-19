class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> techStack;
  final String? liveUrl;
  final String? repoUrl;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.techStack,
    this.liveUrl,
    this.repoUrl,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      techStack: (json['techStack'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      liveUrl: json['liveUrl'] as String?,
      repoUrl: json['repoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'techStack': techStack,
      'liveUrl': liveUrl,
      'repoUrl': repoUrl,
    };
  }
}
