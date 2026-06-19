import '../../domain/entities/home_entity.dart';

/// Data-layer shape. Knows about JSON; the domain layer never does.
class HomeModel {
  final String fullName;
  final String headline;
  final String tagline;
  final String avatarUrl;
  final List<String> socialLinks;

  const HomeModel({
    required this.fullName,
    required this.headline,
    required this.tagline,
    required this.avatarUrl,
    required this.socialLinks,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      fullName: json['fullName'] as String,
      headline: json['headline'] as String,
      tagline: json['tagline'] as String,
      avatarUrl: json['avatarUrl'] as String,
      socialLinks: (json['socialLinks'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'headline': headline,
      'tagline': tagline,
      'avatarUrl': avatarUrl,
      'socialLinks': socialLinks,
    };
  }

  HomeEntity toEntity() {
    return HomeEntity(
      fullName: fullName,
      headline: headline,
      tagline: tagline,
      avatarUrl: avatarUrl,
      socialLinks: socialLinks,
    );
  }
}
