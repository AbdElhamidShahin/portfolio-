import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/project_entity.dart';

/// A single project card: thumbnail, title, description, tech tags,
/// and conditional GitHub / Google Play icon buttons.
///
/// Stateless-except-for-hover: the parent list/grid passes [ProjectEntity]
/// in directly so this widget never rebuilds on unrelated Cubit state changes.
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
                  // Only render the action row if at least one link URL exists
                  if (project.githubUrl != null ||
                      project.googlePlayUrl != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: AppSpacing.md),
                    _ProjectLinkRow(project: project),
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

// ─── Link icon row ────────────────────────────────────────────────────────────

class _ProjectLinkRow extends StatelessWidget {
  final ProjectEntity project;

  const _ProjectLinkRow({required this.project});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (project.githubUrl != null)
          _LinkIconButton(
            tooltip: 'View on GitHub',
            icon: _GitHubIcon(),
            onTap: () => _launch(project.githubUrl!),
          ),
        if (project.githubUrl != null && project.googlePlayUrl != null)
          const SizedBox(width: AppSpacing.xs),
        if (project.googlePlayUrl != null)
          _LinkIconButton(
            tooltip: 'View on Google Play',
            icon: const Icon(
              Icons.play_arrow_rounded,
              size: 17,
              color: AppColors.textSecondary,
            ),
            onTap: () => _launch(project.googlePlayUrl!),
          ),
      ],
    );
  }
}

class _LinkIconButton extends StatefulWidget {
  final String tooltip;
  final Widget icon;
  final VoidCallback onTap;

  const _LinkIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_LinkIconButton> createState() => _LinkIconButtonState();
}

class _LinkIconButtonState extends State<_LinkIconButton> {
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
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.bgElevated : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: _isHovered
                    ? AppColors.borderDefault
                    : Colors.transparent,
              ),
            ),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

/// Custom painted GitHub logo — avoids any icon font dependency.
class _GitHubIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 17,
      height: 17,
      child: CustomPaint(painter: _GitHubPainter()),
    );
  }
}

class _GitHubPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.fill;

    // Simplified GitHub Octocat silhouette drawn as a rounded blob
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.44;

    path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));

    // Ear notches (top-right and top-left)
    final earR = r * 0.22;
    path.addOval(Rect.fromCircle(
      center: Offset(cx + r * 0.60, cy - r * 0.62),
      radius: earR,
    ));
    path.addOval(Rect.fromCircle(
      center: Offset(cx - r * 0.60, cy - r * 0.62),
      radius: earR,
    ));

    canvas.drawPath(path, paint);

    // Eye holes (white cutouts via blend)
    final eyePaint = Paint()
      ..color = AppColors.bgSurface
      ..style = PaintingStyle.fill;
    final eyeR = r * 0.13;
    canvas.drawOval(
      Rect.fromCircle(center: Offset(cx - r * 0.26, cy - r * 0.10), radius: eyeR),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCircle(center: Offset(cx + r * 0.26, cy - r * 0.10), radius: eyeR),
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Thumbnail ────────────────────────────────────────────────────────────────

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

// ─── Tech stack ───────────────────────────────────────────────────────────────

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
