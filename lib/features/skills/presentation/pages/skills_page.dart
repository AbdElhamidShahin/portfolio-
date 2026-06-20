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
import '../../domain/entities/skill_entity.dart';
import '../cubit/skills_cubit.dart';
import '../cubit/skills_state.dart';

/// Skills section — body-only, no Scaffold of its own.
/// Provides the Cubit, triggers the initial load, and delegates all
/// rendering to focused private widgets below.
class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SkillsCubit>()..loadSkills(),
      child: const ColoredBox(
        color: AppColors.bgBase,
        child: _SkillsBody(),
      ),
    );
  }
}

// ─── Body ────────────────────────────────────────────────────────────────────

class _SkillsBody extends StatelessWidget {
  const _SkillsBody();

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
          _SkillsHeader(),
          SizedBox(height: AppSpacing.xxl),
          _SkillsContent(),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SkillsHeader extends StatelessWidget {
  const _SkillsHeader();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WHAT I WORK WITH', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Skills',
          style: isMobile
              ? AppTextStyles.displayLg.copyWith(fontSize: 32)
              : AppTextStyles.displayLg,
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'Technologies and patterns I rely on daily — grouped by '
            'the problems they solve.',
            style: AppTextStyles.bodyLg,
          ),
        ),
      ],
    );
  }
}

// ─── BlocBuilder — smallest widget that needs state ──────────────────────────

class _SkillsContent extends StatelessWidget {
  const _SkillsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkillsCubit, SkillsState>(
      builder: (context, state) {
        return switch (state) {
          SkillsInitial() || SkillsLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              child: LoadingIndicator(),
            ),
          SkillsError(message: final msg) => _SkillsErrorView(message: msg),
          SkillsLoaded(skills: final skills) => skills.isEmpty
              ? const _SkillsEmptyView()
              : _SkillsGrid(skills: skills),
        };
      },
    );
  }
}

// ─── Grouped grid ────────────────────────────────────────────────────────────

class _SkillsGrid extends StatelessWidget {
  final List<SkillEntity> skills;

  const _SkillsGrid({required this.skills});

  /// Preserve insertion order of categories from the service.
  List<String> _orderedCategories() {
    final seen = <String>{};
    final ordered = <String>[];
    for (final s in skills) {
      if (seen.add(s.category)) ordered.add(s.category);
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);
    final isTablet = AppBreakpoints.isTablet(width);

    // Number of category columns on different breakpoints
    final categoryCols = isMobile ? 1 : isTablet ? 2 : 2;

    final categories = _orderedCategories();

    // Pair up categories for the two-column layout on tablet/desktop
    final rows = <List<String>>[];
    for (var i = 0; i < categories.length; i += categoryCols) {
      rows.add(
        categories.sublist(
          i,
          (i + categoryCols).clamp(0, categories.length),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows) ...[
          if (categoryCols == 1)
            _CategoryGroup(
              category: row[0],
              skills: skills.where((s) => s.category == row[0]).toList(),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < row.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: _CategoryGroup(
                      category: row[i],
                      skills:
                          skills.where((s) => s.category == row[i]).toList(),
                    ),
                  ),
                ],
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ],
    );
  }
}

// ─── Single category group ────────────────────────────────────────────────────

class _CategoryGroup extends StatelessWidget {
  final String category;
  final List<SkillEntity> skills;

  const _CategoryGroup({
    required this.category,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();

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
          _CategoryHeader(label: skills.first.categoryLabel),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < skills.length; i++) ...[
            _SkillRow(skill: skills[i]),
            if (i < skills.length - 1) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(
                height: 1,
                color: AppColors.borderSubtle,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String label;

  const _CategoryHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            gradient: AppColors.gradientBrand,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ─── Single skill row with animated proficiency bar ───────────────────────────

class _SkillRow extends StatelessWidget {
  final SkillEntity skill;

  const _SkillRow({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.name,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    skill.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              '${skill.proficiency}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontFamily: AppTextStyles.fontMono,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        _ProficiencyBar(proficiency: skill.proficiency),
      ],
    );
  }
}

// ─── Animated proficiency bar ─────────────────────────────────────────────────

class _ProficiencyBar extends StatefulWidget {
  final int proficiency;

  const _ProficiencyBar({required this.proficiency});

  @override
  State<_ProficiencyBar> createState() => _ProficiencyBarState();
}

class _ProficiencyBarState extends State<_ProficiencyBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.scrollReveal,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    // Start after a short delay so the bar animates in as the section scrolls
    Future.delayed(AppDurations.moderate, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fraction = widget.proficiency / 100.0;

    return SizedBox(
      height: 4,
      child: ClipRRect(
        borderRadius: AppRadius.pill,
        child: Stack(
          children: [
            // Track
            const ColoredBox(
              color: AppColors.bgSurface,
              child: SizedBox.expand(),
            ),
            // Filled portion
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return FractionallySizedBox(
                  widthFactor: fraction * _animation.value,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientBrand,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _SkillsErrorView extends StatelessWidget {
  final String message;

  const _SkillsErrorView({required this.message});

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
              'Couldn\'t load skills',
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
              onPressed: () => context.read<SkillsCubit>().loadSkills(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsEmptyView extends StatelessWidget {
  const _SkillsEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.code_off_outlined,
              color: AppColors.textTertiary,
              size: AppSpacing.xxl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No skills found', style: AppTextStyles.bodyMd),
          ],
        ),
      ),
    );
  }
}
