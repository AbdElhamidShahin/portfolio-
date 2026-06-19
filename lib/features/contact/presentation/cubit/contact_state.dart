import '../../domain/entities/contact_info_entity.dart';

sealed class ContactState {
  const ContactState();
}

final class ContactInitial extends ContactState {
  const ContactInitial();
}

final class ContactLoading extends ContactState {
  const ContactLoading();
}

final class ContactLoaded extends ContactState {
  final ContactInfoEntity info;
  const ContactLoaded(this.info);
}

final class ContactError extends ContactState {
  final String message;
  const ContactError(this.message);
}

final class ContactMessageSending extends ContactState {
  const ContactMessageSending();
}

final class ContactMessageSent extends ContactState {
  const ContactMessageSent();
}

final class ContactMessageError extends ContactState {
  final String message;
  const ContactMessageError(this.message);
}
