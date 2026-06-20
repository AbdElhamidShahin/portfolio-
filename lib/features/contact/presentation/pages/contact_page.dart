import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../cubit/contact_cubit.dart';
import '../cubit/contact_state.dart';
import '../widgets/contact_form.dart';

/// Contact section — body-only, no Scaffold of its own.
/// Provides the Cubit, triggers the initial load, and delegates
/// all rendering to focused private widgets below.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContactCubit>()..loadContactInfo(),
      child: const ColoredBox(
        color: AppColors.bgBase,
        child: _ContactBody(),
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _ContactBody extends StatelessWidget {
  const _ContactBody();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);
    final isTablet = AppBreakpoints.isTablet(width);

    final horizontalPadding = isMobile
        ? AppSpacing.lg
        : isTablet
            ? AppSpacing.xxl
            : AppSpacing.huge;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        AppSpacing.xxl,
        horizontalPadding,
        AppSpacing.xxxl,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ContactHeader(),
          SizedBox(height: AppSpacing.xxl),
          _ContactContent(),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _ContactHeader extends StatelessWidget {
  const _ContactHeader();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('GET IN TOUCH', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Contact',
          style: isMobile
              ? AppTextStyles.displayLg.copyWith(fontSize: 32)
              : AppTextStyles.displayLg,
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Have a project, an opportunity, or just want to say hello? '
            'My inbox is always open.',
            style: AppTextStyles.bodyLg,
          ),
        ),
      ],
    );
  }
}

// ─── BlocBuilder — scoped to the smallest widget that needs contact info ──────

class _ContactContent extends StatelessWidget {
  const _ContactContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      // Only rebuild when info-load state changes — not on form send states
      buildWhen: (prev, curr) =>
          curr is ContactInitial ||
          curr is ContactLoading ||
          curr is ContactLoaded ||
          curr is ContactError,
      builder: (context, state) {
        return switch (state) {
          ContactInitial() || ContactLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              child: LoadingIndicator(),
            ),
          ContactError(message: final msg) => _ContactErrorView(message: msg),
          // For all form-send states the layout stays mounted; ContactForm
          // handles its own sub-state via BlocConsumer inside it.
          _ when _isLoaded(context) => _ContactLayout(
              info: _resolveInfo(context)!,
            ),
          _ => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              child: LoadingIndicator(),
            ),
        };
      },
    );
  }

  // Helpers to extract loaded info even when state is a form-send sub-state
  static bool _isLoaded(BuildContext context) {
    return _resolveInfo(context) != null;
  }

  static ContactInfoEntity? _resolveInfo(BuildContext context) {
    // Walk up through all form-send states to find the last loaded info
    // stored in the cubit's stream history via the cubit itself.
    // Since the cubit always restores ContactLoaded after send, we check
    // the cubit's state directly rather than the snapshot passed to builder.
    final cubitState = context.read<ContactCubit>().state;
    if (cubitState is ContactLoaded) return cubitState.info;
    return null;
  }
}

// ─── Two-column responsive layout ────────────────────────────────────────────

class _ContactLayout extends StatelessWidget {
  final ContactInfoEntity info;

  const _ContactLayout({required this.info});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);
    final isTablet = AppBreakpoints.isTablet(width);
    final isCompact = isMobile || isTablet;

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoColumn(info: info),
          const SizedBox(height: AppSpacing.xxl),
          const ContactForm(),
        ],
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: _InfoColumn(info: info)),
          const SizedBox(width: AppSpacing.xxxl),
          const Expanded(flex: 6, child: ContactForm()),
        ],
      ),
    );
  }
}

// ─── Left column: info items ──────────────────────────────────────────────────

class _InfoColumn extends StatelessWidget {
  final ContactInfoEntity info;

  const _InfoColumn({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s Work Together',
          style: AppTextStyles.headingLg.copyWith(fontSize: 24),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'I\'m currently open to new opportunities — '
          'freelance, full-time, or contract work.',
          style: AppTextStyles.bodyMd,
        ),
        const SizedBox(height: AppSpacing.xl),
        _AvailabilityBadge(),
        const SizedBox(height: AppSpacing.xl),
        _InfoDivider(),
        const SizedBox(height: AppSpacing.lg),
        ContactInfoRow(
          icon: Icons.location_on_outlined,
          label: 'LOCATION',
          value: info.location,
        ),
        const SizedBox(height: AppSpacing.md),
        ContactInfoRow(
          icon: Icons.email_outlined,
          label: 'EMAIL',
          value: info.email,
          onTap: () => _launch('mailto:${info.email}'),
        ),
        const SizedBox(height: AppSpacing.md),
        ContactInfoRow(
          icon: Icons.code_rounded,
          label: 'GITHUB',
          value: _displayUrl(info.githubUrl),
          onTap: () => _launch(info.githubUrl),
        ),
        const SizedBox(height: AppSpacing.md),
        ContactInfoRow(
          icon: Icons.work_outline_rounded,
          label: 'LINKEDIN',
          value: _displayUrl(info.linkedInUrl),
          onTap: () => _launch(info.linkedInUrl),
        ),
      ],
    );
  }

  String _displayUrl(String url) {
    // Strip protocol for display: https://github.com/X  →  github.com/X
    return url.replaceFirst(RegExp(r'https?://'), '');
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _AvailabilityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withOpacity(0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Available for opportunities',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.borderSubtle);
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _ContactErrorView extends StatelessWidget {
  final String message;

  const _ContactErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: AppSpacing.xxl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Couldn\'t load contact info',
              style: AppTextStyles.headingLg.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: () => context.read<ContactCubit>().loadContactInfo(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
