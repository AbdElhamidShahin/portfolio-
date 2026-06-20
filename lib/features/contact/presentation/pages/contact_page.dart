import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../cubit/contact_cubit.dart';
import '../cubit/contact_state.dart';
import '../widgets/contact_form.dart';

/// Contact section — body-only, no Scaffold of its own.
///
/// Provides the [ContactCubit], triggers the initial contact-info load,
/// and lays out a two-column desktop view (info / form) that collapses
/// to a single stacked column on mobile, per [AppBreakpoints].
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContactCubit>()..loadContactInfo(),
      child: const ColoredBox(
        color: AppColors.bgElevated,
        child: _ContactBody(),
      ),
    );
  }
}

// ─── Body ────────────────────────────────────────────────────────────────────

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
          _ContactLayout(),
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
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            "Have an opportunity, a question, or just want to say hello? "
            "My inbox is always open.",
            style: AppTextStyles.bodyLg,
          ),
        ),
      ],
    );
  }
}

// ─── Responsive layout: info column + form column ────────────────────────────

class _ContactLayout extends StatelessWidget {
  const _ContactLayout();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);
    final isTablet = AppBreakpoints.isTablet(width);
    final isCompact = isMobile || isTablet;

    if (isCompact) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ContactInfoSection(),
          SizedBox(height: AppSpacing.xxl),
          ContactForm(),
        ],
      );
    }

    // Desktop: two columns — info on the left, form on the right.
    return const ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 1200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: _ContactInfoSection()),
          SizedBox(width: AppSpacing.xxxl),
          Expanded(flex: 5, child: ContactForm()),
        ],
      ),
    );
  }
}

// ─── Left column — BlocBuilder scoped to info-loading lifecycle only ────────

class _ContactInfoSection extends StatelessWidget {
  const _ContactInfoSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      // Only the contact-info loading lifecycle matters here — message
      // sending states are handled entirely inside ContactForm and must
      // never trigger a rebuild of this column.
      buildWhen: (previous, current) =>
          current is ContactInitial ||
          current is ContactLoading ||
          current is ContactLoaded ||
          current is ContactError,
      builder: (context, state) {
        return switch (state) {
          ContactInitial() || ContactLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: LoadingIndicator(),
            ),
          ContactError(message: final msg) => _InfoErrorView(message: msg),
          ContactLoaded(info: final info) => _InfoColumn(info: info),
          ContactMessageSending() ||
          ContactMessageSent() ||
          ContactMessageError() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: LoadingIndicator(),
            ),
        };
      },
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final ContactInfoEntity info;

  const _InfoColumn({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's build something great",
          style: AppTextStyles.headingLg.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "Reach out directly through any of the channels below, "
          "or use the form to send me a message.",
          style: AppTextStyles.bodyMd,
        ),
        const SizedBox(height: AppSpacing.xl),
        _ContactInfoRow(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: info.location,
        ),
        const SizedBox(height: AppSpacing.lg),
        _ContactInfoRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: info.email,
          copyValue: info.email,
        ),
        const SizedBox(height: AppSpacing.xl),
        const Divider(color: AppColors.borderSubtle, height: 1),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'FIND ME ON',
          style: AppTextStyles.caption.copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _SocialLinkChip(
              icon: Icons.code_rounded,
              label: 'GitHub',
              url: info.githubUrl,
            ),
            _SocialLinkChip(
              icon: Icons.business_center_outlined,
              label: 'LinkedIn',
              url: info.linkedInUrl,
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? copyValue;

  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.copyValue,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            gradient: AppColors.gradientBrand,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(letterSpacing: 0.6),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );

    if (copyValue == null) return row;

    return _Copyable(value: copyValue!, child: row);
  }
}

class _SocialLinkChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialLinkChip({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return _Copyable(
      value: url,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.tagBg,
          borderRadius: AppRadius.pill,
          border: Border.all(color: AppColors.tagBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.tagText),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.tagText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wraps [child] with hover + tap-to-copy behavior. Used for any contact
/// detail (email, GitHub, LinkedIn) that's "clickable" without pulling
/// in a URL-launching dependency: tapping copies the value to the
/// clipboard and surfaces a confirmation via [SnackBar].
class _Copyable extends StatefulWidget {
  final String value;
  final Widget child;

  const _Copyable({required this.value, required this.child});

  @override
  State<_Copyable> createState() => _CopyableState();
}

class _CopyableState extends State<_Copyable> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  Future<void> _handleTap() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "${widget.value}" to clipboard'),
        backgroundColor: AppColors.bgSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedOpacity(
          duration: AppDurations.fast,
          opacity: _isHovered ? 0.75 : 1,
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _InfoErrorView extends StatelessWidget {
  final String message;

  const _InfoErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppSpacing.xxl,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Couldn't load contact info",
            style: AppTextStyles.headingLg.copyWith(fontSize: 18),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(message, style: AppTextStyles.bodyMd),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: () => context.read<ContactCubit>().loadContactInfo(),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
