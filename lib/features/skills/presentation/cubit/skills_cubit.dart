import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_skills_usecase.dart';
import 'skills_state.dart';

class SkillsCubit extends Cubit<SkillsState> {
  final GetSkillsUseCase _getSkillsUseCase;

  SkillsCubit(this._getSkillsUseCase) : super(const SkillsInitial());

  Future<void> loadSkills() async {
    emit(const SkillsLoading());
    final result = await _getSkillsUseCase();
    result.when(
      success: (skills) => emit(SkillsLoaded(skills)),
      failure: (failure) => emit(SkillsError(failure.message)),
    );
  }
}
