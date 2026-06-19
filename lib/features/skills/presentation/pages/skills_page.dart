import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/skills_cubit.dart';
import '../cubit/skills_state.dart';

/// Skeleton only — no real UI yet.
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
    return Scaffold(
      body: SafeArea(
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
