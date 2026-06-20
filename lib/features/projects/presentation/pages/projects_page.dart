import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/project_entity.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';
import '../widgets/project_card.dart';

/// Entry point for the Projects feature.
/// A body-only section meant to be placed inside the App Shell's single
/// Scaffold/scroll view — it does NOT own a Scaffold or scroll view of
/// its own. Provides the Cubit and triggers the initial load; all actual
/// rendering happens in [_ProjectsBody] and below, kept as small and
/// state-scoped as possible.
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProjectsCubit>()..loadProjects(),
      child: const ColoredBox(
        color: AppColors.bgBase,
        child: _ProjectsBody(),
      ),
    );
  }
}

class _ProjectsBody extends StatelessWidget {
  const _ProjectsBody();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = _horizontalPadding(context);

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
          _ProjectsHeader(),
          SizedBox(height: AppSpacing.xxl),
          _ProjectsContent(),
        ],
      ),
    );
  }

  static double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (AppBreakpoints.isMobile(width)) return AppSpacing.lg;
    if (AppBreakpoints.isTablet(width)) return AppSpacing.xxl;
    return AppSpacing.huge;
  }
}

class _ProjectsHeader extends StatelessWidget {
  const _ProjectsHeader();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final titleStyle = AppBreakpoints.isMobile(width)
        ? AppTextStyles.displayLg.copyWith(fontSize: 32)
        : AppTextStyles.displayLg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SELECTED WORK', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.sm),
        Text('Projects', style: titleStyle),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            'A selection of apps I\'ve designed and built end-to-end — '
            'from architecture to the pixels you see on screen.',
            style: AppTextStyles.bodyLg,
          ),
        ),
      ],
    );
  }
}

/// Only this widget rebuilds when [ProjectsState] changes — the header
/// and the section background above never do.
class _ProjectsContent extends StatelessWidget {
  const _ProjectsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, ProjectsState>(
      builder: (context, state) {
        return switch (state) {
          ProjectsInitial() || ProjectsLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              child: LoadingIndicator(),
            ),
          ProjectsError(message: final message) =>
            _ProjectsErrorView(message: message),
          ProjectsLoaded(projects: final projects) => projects.isEmpty
              ? const _ProjectsEmptyView()
              : _ProjectsGrid(projects: projects),
        };
      },
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final List<ProjectEntity> projects;

  const _ProjectsGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = AppBreakpoints.isMobile(width)
        ? 1
        : AppBreakpoints.isTablet(width)
            ? 2
            : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.lg,
        crossAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.72,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => ProjectCard(project: projects[index]),
    );
  }
}

class _ProjectsErrorView extends StatelessWidget {
  final String message;

  const _ProjectsErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
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
              'Couldn\'t load projects',
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
              onPressed: () => context.read<ProjectsCubit>().loadProjects(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsEmptyView extends StatelessWidget {
  const _ProjectsEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.folder_open_outlined,
              color: AppColors.textTertiary,
              size: AppSpacing.xxl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No projects yet', style: AppTextStyles.bodyMd),
          ],
        ),
      ),
    );
  }
}
