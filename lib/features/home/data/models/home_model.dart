import '../../domain/entities/home_entity.dart';

/// Data-layer shape. Knows about JSON; the domain layer never does.
class HomeModel {
  final String fullName;
  final String headline;
  final String tagline;
  final String avatarUrl;
  final String cvAssetPath;
  final String whatsappUrl;
  final String githubUrl;
  final String linkedInUrl;
  final String gmailUrl;

  const HomeModel({
    required this.fullName,
    required this.headline,
    required this.tagline,
    required this.avatarUrl,
    required this.cvAssetPath,
    required this.whatsappUrl,
    required this.githubUrl,
    required this.linkedInUrl,
    required this.gmailUrl,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      fullName: json['fullName'] as String,
      headline: json['headline'] as String,
      tagline: json['tagline'] as String,
      avatarUrl: json['avatarUrl'] as String,
      cvAssetPath: json['cvAssetPath'] as String,
      whatsappUrl: json['whatsappUrl'] as String,
      githubUrl: json['githubUrl'] as String,
      linkedInUrl: json['linkedInUrl'] as String,
      gmailUrl: json['gmailUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'headline': headline,
      'tagline': tagline,
      'avatarUrl': avatarUrl,
      'cvAssetPath': cvAssetPath,
      'whatsappUrl': whatsappUrl,
      'githubUrl': githubUrl,
      'linkedInUrl': linkedInUrl,
      'gmailUrl': gmailUrl,
    };
  }

  HomeEntity toEntity() {
    return HomeEntity(
      fullName: fullName,
      headline: headline,
      tagline: tagline,
      avatarUrl: avatarUrl,
      cvAssetPath: cvAssetPath,
      whatsappUrl: whatsappUrl,
      githubUrl: githubUrl,
      linkedInUrl: linkedInUrl,
      gmailUrl: gmailUrl,
    );
  }
}
