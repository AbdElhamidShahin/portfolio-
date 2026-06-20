import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/contact_message_entity.dart';
import '../cubit/contact_cubit.dart';
import '../cubit/contact_state.dart';

/// Premium contact form — Name / Email / Subject / Message.
///
/// Owns its own [TextEditingController]s, [FocusNode]s, and [GlobalKey]
/// for the [Form]. Submission state (sending / sent / error) is handled
/// by a [BlocConsumer] scoped tightly to the submit button area only,
/// so the rest of the page (header, info column) never rebuilds when
/// the cubit emits a message-sending state.
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _subjectController;
  late final TextEditingController _messageController;

  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _subjectFocus;
  late final FocusNode _messageFocus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();

    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _subjectFocus = FocusNode();
    _messageFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }
    if (value.trim().length < 2) {
      return 'Name looks too short.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email.';
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please add a subject.';
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please write a message.';
    }
    if (value.trim().length < 10) {
      return 'Message should be at least 10 characters.';
    }
    return null;
  }

  void _handleSubmit() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final entity = ContactMessageEntity(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    context.read<ContactCubit>().sendMessage(entity);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
    context.read<ContactCubit>().resetMessageState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a Message',
              style: AppTextStyles.headingLg.copyWith(fontSize: 22),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Have a project in mind or just want to say hi? '
              'Fill in the form below.',
              style: AppTextStyles.bodyMd,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _FormField(
                    label: 'Your Name',
                    controller: _nameController,
                    focusNode: _nameFocus,
                    nextFocusNode: _emailFocus,
                    hintText: 'John Doe',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: _validateName,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _FormField(
                    label: 'Your Email',
                    controller: _emailController,
                    focusNode: _emailFocus,
                    nextFocusNode: _subjectFocus,
                    hintText: 'john@example.com',
                    prefixIcon: Icons.alternate_email_rounded,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _FormField(
              label: 'Subject',
              controller: _subjectController,
              focusNode: _subjectFocus,
              nextFocusNode: _messageFocus,
              hintText: "Let's work together",
              prefixIcon: Icons.bookmark_border_rounded,
              validator: _validateSubject,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FormField(
              label: 'Message',
              controller: _messageController,
              focusNode: _messageFocus,
              hintText: 'Tell me a bit about your project or idea...',
              prefixIcon: Icons.chat_bubble_outline_rounded,
              validator: _validateMessage,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: AppSpacing.xl),
            _SubmitSection(
              onSubmit: _handleSubmit,
              onReset: _resetForm,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Styled form field ────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;

  const _FormField({
    required this.label,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    required this.hintText,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          minLines: maxLines > 1 ? maxLines : null,
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
          cursorColor: AppColors.primary400,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              focusNode.unfocus();
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                right: AppSpacing.xs,
              ),
              child: Icon(prefixIcon, size: 18, color: AppColors.textTertiary),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            errorStyle: AppTextStyles.caption.copyWith(
              color: AppColors.error,
              letterSpacing: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: const BorderSide(color: AppColors.borderDefault),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: const BorderSide(color: AppColors.borderDefault),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.button,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Submit button + scoped inline feedback ──────────────────────────────────

class _SubmitSection extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  const _SubmitSection({required this.onSubmit, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      // Only rebuild this scoped widget for message-sending lifecycle
      // states — info-loading states (ContactInitial/Loading/Loaded/Error)
      // are irrelevant here and must not trigger a rebuild.
      buildWhen: (previous, current) =>
          current is ContactMessageSending ||
          current is ContactMessageSent ||
          current is ContactMessageError ||
          previous is ContactMessageSending ||
          previous is ContactMessageSent ||
          previous is ContactMessageError,
      listenWhen: (previous, current) => current is ContactMessageError,
      listener: (context, state) {
        if (state case ContactMessageError(message: final msg)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Couldn\'t send your message: $msg'),
              backgroundColor: AppColors.bgElevated,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ContactMessageSent) {
          return _SuccessBanner(onSendAnother: onReset);
        }

        final isSending = state is ContactMessageSending;
        final hasError = state is ContactMessageError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSending ? null : onSubmit,
                child: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  child: isSending
                      ? const _ButtonSpinner(key: ValueKey('sending'))
                      : const Row(
                          key: ValueKey('idle'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Send Message'),
                            SizedBox(width: AppSpacing.xs),
                            Icon(Icons.send_rounded, size: 16),
                          ],
                        ),
                ),
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 15,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      (state as ContactMessageError).message,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text('Sending...'),
      ],
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final VoidCallback onSendAnother;

  const _SuccessBanner({required this.onSendAnother});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.moderate,
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.12),
        borderRadius: AppRadius.button,
        border: Border.all(color: AppColors.success.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 14,
              color: AppColors.textInverse,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Message sent successfully!',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Thanks for reaching out — I'll get back to you soon.",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSendAnother,
            child: const Text('Send another'),
          ),
        ],
      ),
    );
  }
}
