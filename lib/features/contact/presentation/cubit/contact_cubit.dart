import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact_message_entity.dart';
import '../../domain/usecases/get_contact_info_usecase.dart';
import '../../domain/usecases/send_contact_message_usecase.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final GetContactInfoUseCase _getContactInfoUseCase;
  final SendContactMessageUseCase _sendContactMessageUseCase;

  ContactCubit(
    this._getContactInfoUseCase,
    this._sendContactMessageUseCase,
  ) : super(const ContactInitial());

  Future<void> loadContactInfo() async {
    emit(const ContactLoading());
    final result = await _getContactInfoUseCase();
    result.when(
      success: (info) => emit(ContactLoaded(info)),
      failure: (failure) => emit(ContactError(failure.message)),
    );
  }

  Future<void> sendMessage(ContactMessageEntity message) async {
    emit(const ContactMessageSending());
    final result = await _sendContactMessageUseCase(message);
    result.when(
      success: (_) => emit(const ContactMessageSent()),
      failure: (failure) => emit(ContactMessageError(failure.message)),
    );
  }

  /// Returns the submission lifecycle back to idle so the form can be
  /// reused after a successful send or a failed attempt, without
  /// re-fetching the contact info that's already loaded.
  void resetMessageState() {
    emit(const ContactInitial());
  }
}
