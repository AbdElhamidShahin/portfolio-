import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/project_entity.dart';

/// A single project card: thumbnail, title, description, and tech tags.
///
/// Stateless and self-contained on purpose — it never reads from any
/// Cubit. The parent list/grid passes the [ProjectEntity] in directly,
/// so this widget never rebuilds when unrelated Cubit state changes.
class ProjectCard extends StatefulWidget {
  final ProjectEntity project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: AppDurations.moderate,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: _isHovered
                ? AppColors.borderAccent.withOpacity(0.6)
                : AppColors.borderSubtle,
          ),
          boxShadow: _isHovered ? AppShadows.lg : AppShadows.sm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProjectThumbnail(
              imageUrl: project.thumbnailUrl,
              isHovered: _isHovered,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: AppTextStyles.headingLg.copyWith(fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    project.description,
                    style: AppTextStyles.bodyMd,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _TechStackRow(techStack: project.techStack),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectThumbnail extends StatelessWidget {
  final String imageUrl;
  final bool isHovered;

  const _ProjectThumbnail({required this.imageUrl, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ClipRect(
        child: AnimatedScale(
          duration: AppDurations.moderate,
          curve: Curves.easeOut,
          scale: isHovered ? 1.05 : 1.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const _ThumbnailFallback(isError: false);
            },
            errorBuilder: (context, error, stackTrace) {
              return const _ThumbnailFallback(isError: true);
            },
          ),
        ),
      ),
    );
  }
}

class _ThumbnailFallback extends StatelessWidget {
  final bool isError;

  const _ThumbnailFallback({required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgElevated,
      alignment: Alignment.center,
      child: Icon(
        isError ? Icons.broken_image_outlined : Icons.image_outlined,
        color: AppColors.textDisabled,
        size: AppSpacing.xl,
      ),
    );
  }
}

class _TechStackRow extends StatelessWidget {
  final List<String> techStack;

  const _TechStackRow({required this.techStack});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final tech in techStack) _TechTag(label: tech),
      ],
    );
  }
}

class _TechTag extends StatelessWidget {
  final String label;

  const _TechTag({required this.label});

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
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.tagText,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
