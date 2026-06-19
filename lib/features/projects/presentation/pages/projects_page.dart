import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';

/// Skeleton only — no real UI yet.
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProjectsCubit>()..loadProjects(),
      child: const _ProjectsView(),
    );
  }
}

class _ProjectsView extends StatelessWidget {
  const _ProjectsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProjectsCubit, ProjectsState>(
          builder: (context, state) {
            return switch (state) {
              ProjectsInitial() ||
              ProjectsLoading() => const LoadingIndicator(),
              ProjectsError(message: final msg) =>
                Center(child: Text('Failed to load projects: $msg')),
              ProjectsLoaded() => const Center(child: Text('Projects — TODO')),
            };
          },
        ),
      ),
    );
  }
}
