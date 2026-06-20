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

  Future<void> sendMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    // Guard: do not emit sending if already in that state (double-tap protection)
    if (state is ContactMessageSending) return;

    // Snapshot the loaded info before emitting so we can restore it after
    final currentInfo =
        state is ContactLoaded ? (state as ContactLoaded).info : null;

    emit(const ContactMessageSending());

    final result = await _sendContactMessageUseCase(
      ContactMessageEntity(
        name: name,
        email: email,
        subject: subject,
        message: message,
      ),
    );

    result.when(
      success: (_) => emit(const ContactMessageSent()),
      failure: (failure) => emit(ContactMessageError(failure.message)),
    );

    // After a result, restore the loaded info so the layout stays visible.
    // The form widget listens via BlocConsumer and handles its own local state.
    if (currentInfo != null) {
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) emit(ContactLoaded(currentInfo));
    }
  }
}
