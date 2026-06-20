import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_durations.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../cubit/contact_cubit.dart';
import '../cubit/contact_state.dart';

/// Self-contained contact form.
///
/// Uses [BlocConsumer] so the success/error banner and loading overlay
/// are scoped strictly inside this widget — the outer layout (header,
/// info column) never rebuilds on form state changes.
///
/// Controllers and FocusNodes are created in [initState] and disposed
/// in [dispose] — never inside build().
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers — allocated once, never inside build()
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _subjectCtrl;
  late final TextEditingController _messageCtrl;

  // FocusNodes — allocated once, never inside build()
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _subjectFocus;
  late final FocusNode _messageFocus;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _subjectCtrl = TextEditingController();
    _messageCtrl = TextEditingController();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _subjectFocus = FocusNode();
    _messageFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ContactCubit>().sendMessage(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          subject: _subjectCtrl.text.trim(),
          message: _messageCtrl.text.trim(),
        );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _subjectCtrl.clear();
    _messageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      // Only this widget rebuilds on form-related state transitions
      listenWhen: (prev, curr) =>
          curr is ContactMessageSent ||
          curr is ContactMessageError ||
          curr is ContactMessageSending,
      listener: (context, state) {
        if (state is ContactMessageSent) _clearForm();
      },
      buildWhen: (prev, curr) =>
          curr is ContactMessageSending ||
          curr is ContactMessageSent ||
          curr is ContactMessageError ||
          (prev is ContactMessageSending || prev is ContactMessageSent || prev is ContactMessageError),
      builder: (context, state) {
        final isSending = state is ContactMessageSending;
        final isSent = state is ContactMessageSent;
        final isError = state is ContactMessageError;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send a Message',
                style: AppTextStyles.headingLg.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'I\'ll get back to you within 24 hours.',
                style: AppTextStyles.bodyMd,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Inline feedback banners ──────────────────────────────────
              if (isSent) ...[
                _FeedbackBanner.success(
                  message: 'Message sent! I\'ll be in touch shortly.',
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (isError) ...[
                _FeedbackBanner.error(
                  message: (state as ContactMessageError).message,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ── Form ─────────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            controller: _nameCtrl,
                            focusNode: _nameFocus,
                            nextFocus: _emailFocus,
                            label: 'Name',
                            hint: 'Your full name',
                            enabled: !isSending && !isSent,
                            validator: _validateRequired('Name'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _FormField(
                            controller: _emailCtrl,
                            focusNode: _emailFocus,
                            nextFocus: _subjectFocus,
                            label: 'Email',
                            hint: 'your@email.com',
                            keyboardType: TextInputType.emailAddress,
                            enabled: !isSending && !isSent,
                            validator: _validateEmail,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      controller: _subjectCtrl,
                      focusNode: _subjectFocus,
                      nextFocus: _messageFocus,
                      label: 'Subject',
                      hint: 'What\'s this about?',
                      enabled: !isSending && !isSent,
                      validator: _validateRequired('Subject'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FormField(
                      controller: _messageCtrl,
                      focusNode: _messageFocus,
                      label: 'Message',
                      hint: 'Tell me about your project or opportunity...',
                      maxLines: 5,
                      enabled: !isSending && !isSent,
                      validator: _validateMessage,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: _SubmitButton(
                        isSending: isSending,
                        isSent: isSent,
                        onTap: (isSending || isSent) ? null : _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Validators ─────────────────────────────────────────────────────────────

  static String? Function(String?) _validateRequired(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required.';
      }
      return null;
    };
  }

  static String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message is required.';
    }
    if (value.trim().length < 20) {
      return 'Message must be at least 20 characters.';
    }
    return null;
  }
}

// ─── Reusable themed text field ───────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  final bool enabled;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
    this.validator,
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
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          textInputAction:
              nextFocus != null ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            }
          },
          validator: validator,
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTextStyles.bodyMd.copyWith(color: AppColors.textDisabled),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            errorStyle: AppTextStyles.caption.copyWith(
              color: AppColors.error,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Submit button ─────────────────────────────────────────────────────────────

class _SubmitButton extends StatefulWidget {
  final bool isSending;
  final bool isSent;
  final VoidCallback? onTap;

  const _SubmitButton({
    required this.isSending,
    required this.isSent,
    this.onTap,
  });

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final canTap = !widget.isSending && !widget.isSent;

    return MouseRegion(
      cursor:
          canTap ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDurations.base,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: canTap ? AppColors.gradientBrand : null,
            color: canTap ? null : AppColors.bgSurface,
            borderRadius: AppRadius.button,
            boxShadow: (canTap && _isHovered)
                ? [
                    BoxShadow(
                      color: AppColors.primary500.withOpacity(0.4),
                      blurRadius: 24,
                    )
                  ]
                : [],
          ),
          transform:
              Matrix4.translationValues(0, (canTap && _isHovered) ? -2 : 0, 0),
          child: Center(
            child: widget.isSending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textPrimary,
                    ),
                  )
                : widget.isSent
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Message Sent',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Send Message',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}

// ─── Feedback banner ─────────────────────────────────────────────────────────

class _FeedbackBanner extends StatelessWidget {
  final String message;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;

  const _FeedbackBanner._({
    required this.message,
    required this.borderColor,
    required this.textColor,
    required this.backgroundColor,
    required this.icon,
  });

  factory _FeedbackBanner.success({required String message}) {
    return _FeedbackBanner._(
      message: message,
      borderColor: AppColors.success.withOpacity(0.4),
      textColor: AppColors.success,
      backgroundColor: AppColors.success.withOpacity(0.08),
      icon: Icons.check_circle_outline_rounded,
    );
  }

  factory _FeedbackBanner.error({required String message}) {
    return _FeedbackBanner._(
      message: message,
      borderColor: AppColors.error.withOpacity(0.4),
      textColor: AppColors.error,
      backgroundColor: AppColors.error.withOpacity(0.08),
      icon: Icons.error_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.button,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMd.copyWith(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Social link row (used in the info column on mobile) ─────────────────────

/// Exported for use in contact_page.dart's info column.
class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const ContactInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.button,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Icon(icon, size: 16, color: AppColors.primary400),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: onTap != null
                          ? AppColors.primary400
                          : AppColors.textPrimary,
                      decoration: onTap != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: AppColors.primary400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
