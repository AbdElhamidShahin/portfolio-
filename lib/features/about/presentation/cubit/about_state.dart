import '../../domain/entities/about_entity.dart';

sealed class AboutState {
  const AboutState();
}

final class AboutInitial extends AboutState {
  const AboutInitial();
}

final class AboutLoading extends AboutState {
  const AboutLoading();
}

final class AboutLoaded extends AboutState {
  final AboutEntity about;
  const AboutLoaded(this.about);
}

final class AboutError extends AboutState {
  final String message;
  const AboutError(this.message);
}
