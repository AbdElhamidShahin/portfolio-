import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_home_profile_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeProfileUseCase _getHomeProfileUseCase;

  HomeCubit(this._getHomeProfileUseCase) : super(const HomeInitial());

  Future<void> loadHomeProfile() async {
    emit(const HomeLoading());
    final result = await _getHomeProfileUseCase();
    result.when(
      success: (profile) => emit(HomeLoaded(profile)),
      failure: (failure) => emit(HomeError(failure.message)),
    );
  }
}
