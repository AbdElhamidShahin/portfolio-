import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/skills_cubit.dart';
import '../cubit/skills_state.dart';

/// Skeleton only — no real UI yet.
/// A body-only section meant to be placed inside the App Shell's single
/// Scaffold/scroll view — it does NOT own a Scaffold of its own.
class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SkillsCubit>()..loadSkills(),
      child: const _SkillsView(),
    );
  }
}

class _SkillsView extends StatelessWidget {
  const _SkillsView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.massive * 4),
        child: BlocBuilder<SkillsCubit, SkillsState>(
          builder: (context, state) {
            return switch (state) {
              SkillsInitial() || SkillsLoading() => const LoadingIndicator(),
              SkillsError(message: final msg) =>
                Center(child: Text('Failed to load skills: $msg')),
              SkillsLoaded() => const Center(child: Text('Skills — TODO')),
            };
          },
        ),
      ),
    );
  }
}
