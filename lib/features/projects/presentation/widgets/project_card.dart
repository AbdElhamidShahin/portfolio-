import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Stack(
              children: [
                _ProjectThumbnail(
                  imageUrl: project.thumbnailUrl,
                  isHovered: _isHovered,
                ),
                if (project.repoUrl != null)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: _ThumbnailIconButton(
                      icon: Icons.code_rounded,
                      tooltip: 'View on GitHub',
                      url: project.repoUrl!,
                    ),
                  ),
              ],
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
                  if (project.playStoreUrl != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _GooglePlayBadge(url: project.playStoreUrl!),
                  ],
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

/// Opens [url] in the platform's default handler (browser tab on web).
/// Shared by every tappable link in this card so the try/guard logic
/// lives in exactly one place.
Future<void> _launchProjectUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Small icon button overlaid on the thumbnail's corner (e.g. GitHub).
/// Stops the tap from bubbling up to anything behind the thumbnail.
class _ThumbnailIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final String url;

  const _ThumbnailIconButton({
    required this.icon,
    required this.tooltip,
    required this.url,
  });

  @override
  State<_ThumbnailIconButton> createState() => _ThumbnailIconButtonState();
}

class _ThumbnailIconButtonState extends State<_ThumbnailIconButton> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: GestureDetector(
          onTap: () => _launchProjectUrl(widget.url),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.bgBase.withOpacity(0.85)
                  : AppColors.bgBase.withOpacity(0.55),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: _isHovered
                    ? AppColors.borderAccent.withOpacity(0.6)
                    : AppColors.borderSubtle,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// "Get it on Google Play" badge, shown only when a project has a
/// [ProjectEntity.playStoreUrl]. Styled to evoke the familiar store
/// badge shape without reproducing Google's actual logo/artwork.
class _GooglePlayBadge extends StatefulWidget {
  final String url;

  const _GooglePlayBadge({required this.url});

  @override
  State<_GooglePlayBadge> createState() => _GooglePlayBadgeState();
}

class _GooglePlayBadgeState extends State<_GooglePlayBadge> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: () => _launchProjectUrl(widget.url),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.bgSurfaceHover : AppColors.bgBase,
            borderRadius: AppRadius.button,
            border: Border.all(
              color: _isHovered
                  ? AppColors.borderStrong
                  : AppColors.borderDefault,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                size: 22,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GET IT ON',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 9,
                      letterSpacing: 0.6,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    'Google Play',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TechStackRow extends StatelessWidget {
  final List<String> techStack;

  /// Caps how many tags are rendered before collapsing the rest into a
  /// "+N" badge. Without a cap, real project data (6+ tags) wraps to an
  /// unbounded number of rows and overflows the card's fixed grid-cell
  /// height — this keeps the tag area's height deterministic.
  static const int _maxVisibleTags = 4;

  const _TechStackRow({required this.techStack});

  @override
  Widget build(BuildContext context) {
    final visibleTags = techStack.take(_maxVisibleTags).toList();
    final hiddenCount = techStack.length - visibleTags.length;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final tech in visibleTags) _TechTag(label: tech),
        if (hiddenCount > 0) _TechTag(label: '+$hiddenCount'),
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
