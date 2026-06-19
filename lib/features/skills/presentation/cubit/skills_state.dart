import '../../domain/entities/skill_entity.dart';

sealed class SkillsState {
  const SkillsState();
}

final class SkillsInitial extends SkillsState {
  const SkillsInitial();
}

final class SkillsLoading extends SkillsState {
  const SkillsLoading();
}

final class SkillsLoaded extends SkillsState {
  final List<SkillEntity> skills;
  const SkillsLoaded(this.skills);
}

final class SkillsError extends SkillsState {
  final String message;
  const SkillsError(this.message);
}
