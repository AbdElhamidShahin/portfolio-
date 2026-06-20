import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/about_entity.dart';
import '../cubit/about_cubit.dart';
import '../cubit/about_state.dart';

/// About section — body-only, no Scaffold of its own.
/// Provides the Cubit and triggers the initial load. All rendering
/// is delegated to focused private widgets below.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AboutCubit>()..loadAbout(),
      child: const ColoredBox(
        color: AppColors.bgElevated,
        child: _AboutBody(),
      ),
    );
  }
}

// ─── Body ────────────────────────────────────────────────────────────────────

class _AboutBody extends StatelessWidget {
  const _AboutBody();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _AboutHeader(),
          SizedBox(height: AppSpacing.xxl),
          _AboutContent(),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WHO I AM', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'About Me',
          style: isMobile
              ? AppTextStyles.displayLg.copyWith(fontSize: 32)
              : AppTextStyles.displayLg,
        ),
      ],
    );
  }
}

// ─── BlocBuilder scope — smallest widget that needs state ─────────────────────

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutCubit, AboutState>(
      builder: (context, state) {
        return switch (state) {
          AboutInitial() || AboutLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              child: LoadingIndicator(),
            ),
          AboutError(message: final msg) => _AboutErrorView(message: msg),
          AboutLoaded(about: final about) => _AboutLayout(about: about),
        };
      },
    );
  }
}

// ─── Responsive layout ────────────────────────────────────────────────────────

class _AboutLayout extends StatelessWidget {
  final AboutEntity about;

  const _AboutLayout({required this.about});

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
          _BioColumn(about: about),
          const SizedBox(height: AppSpacing.xxl),
          _InfoColumn(about: about),
        ],
      );
    }

    // Desktop: two-column, left = bio, right = info cards
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _BioColumn(about: about)),
          const SizedBox(width: AppSpacing.xxxl),
          Expanded(flex: 4, child: _InfoColumn(about: about)),
        ],
      ),
    );
  }
}

// ─── Left column: bio text + highlights ──────────────────────────────────────

class _BioColumn extends StatelessWidget {
  final AboutEntity about;

  const _BioColumn({required this.about});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetaRow(location: about.location, availability: about.availability),
        const SizedBox(height: AppSpacing.xl),
        Text(about.bio, style: AppTextStyles.bodyLg),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'What I bring',
          style: AppTextStyles.headingLg.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.md),
        _HighlightsList(highlights: about.highlights),
      ],
    );
  }
}

// ─── Right column: education card + focus area chips ─────────────────────────

class _InfoColumn extends StatelessWidget {
  final AboutEntity about;

  const _InfoColumn({required this.about});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EducationCard(education: about.education),
        const SizedBox(height: AppSpacing.xl),
        _FocusAreasCard(focusAreas: about.focusAreas),
      ],
    );
  }
}

// ─── Meta row: location + availability ───────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final String location;
  final String availability;

  const _MetaRow({required this.location, required this.availability});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        _MetaBadge(icon: Icons.location_on_outlined, label: location),
        _MetaBadge(icon: Icons.work_outline_rounded, label: availability),
      ],
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.primary400),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─── Highlight list ───────────────────────────────────────────────────────────

class _HighlightsList extends StatelessWidget {
  final List<String> highlights;

  const _HighlightsList({required this.highlights});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in highlights) ...[
          _HighlightItem(text: item),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final String text;

  const _HighlightItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              gradient: AppColors.gradientBrand,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMd),
        ),
      ],
    );
  }
}

// ─── Education card ───────────────────────────────────────────────────────────

class _EducationCard extends StatelessWidget {
  final EducationEntity education;

  const _EducationCard({required this.education});

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  gradient: AppColors.gradientBrand,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Education',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            education.degree,
            style: AppTextStyles.headingLg.copyWith(fontSize: 17),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            education.institution,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GraduationBadge(date: education.graduationDate),
        ],
      ),
    );
  }
}

class _GraduationBadge extends StatelessWidget {
  final String date;

  const _GraduationBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.tagBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 11,
            color: AppColors.tagText,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            'Graduating $date',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.tagText,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Focus areas card ─────────────────────────────────────────────────────────

class _FocusAreasCard extends StatelessWidget {
  final List<String> focusAreas;

  const _FocusAreasCard({required this.focusAreas});

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.accentViolet.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 18,
                  color: AppColors.accentViolet,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Focus Areas',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final area in focusAreas) _FocusChip(label: area),
            ],
          ),
        ],
      ),
    );
  }
}

class _FocusChip extends StatefulWidget {
  final String label;

  const _FocusChip({required this.label});

  @override
  State<_FocusChip> createState() => _FocusChipState();
}

class _FocusChipState extends State<_FocusChip> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.primary500.withOpacity(0.15) : AppColors.tagBg,
          borderRadius: AppRadius.pill,
          border: Border.all(
            color: _isHovered ? AppColors.primary400.withOpacity(0.6) : AppColors.tagBorder,
          ),
        ),
        child: Text(
          widget.label,
          style: AppTextStyles.caption.copyWith(
            color: _isHovered ? AppColors.primary400 : AppColors.tagText,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

// ─── Shared surface card container ───────────────────────────────────────────

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

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
      child: child,
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _AboutErrorView extends StatelessWidget {
  final String message;

  const _AboutErrorView({required this.message});

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
              'Couldn\'t load profile',
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
              onPressed: () => context.read<AboutCubit>().loadAbout(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
