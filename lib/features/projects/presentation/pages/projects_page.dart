import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../data/models/project_model.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';
import '../widgets/project_card.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: BlocBuilder<ProjectsCubit, ProjectsState>(
            builder: (context, state) {
              return switch (state) {
                ProjectsInitial() || ProjectsLoading() =>
                  const LoadingIndicator(),
                ProjectsError(message: final msg) => _ErrorView(message: msg),
                ProjectsLoaded(projects: final projects) =>
                  _ProjectsGrid(projects: projects),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final List<ProjectModel> projects;
  const _ProjectsGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return const Center(child: Text('No projects to display.'));
    }

    return GridView.builder(
      itemCount: projects.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 380,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) => ProjectCard(project: projects[index]),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Failed to load projects: $message',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
