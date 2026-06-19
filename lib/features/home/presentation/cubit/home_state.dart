import '../../domain/entities/home_entity.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  final HomeEntity profile;
  const HomeLoaded(this.profile);
}

final class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
