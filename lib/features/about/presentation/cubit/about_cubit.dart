import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_about_usecase.dart';
import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  final GetAboutUseCase _getAboutUseCase;

  AboutCubit(this._getAboutUseCase) : super(const AboutInitial());

  Future<void> loadAbout() async {
    emit(const AboutLoading());
    final result = await _getAboutUseCase();
    result.when(
      success: (about) => emit(AboutLoaded(about)),
      failure: (failure) => emit(AboutError(failure.message)),
    );
  }
}
