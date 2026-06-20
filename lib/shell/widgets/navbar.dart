import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../controller/portfolio_section.dart';

/// Sticky, frosted-glass top navigation bar.
///
/// On mobile (per [AppBreakpoints]) the link row collapses into a single
/// menu button that opens the drawer; [onMenuTap] is only ever supplied
/// in that case, so this widget stays presentation-only and never knows
/// how the drawer is opened.
class Navbar extends StatelessWidget {
  final PortfolioSection? activeSection;
  final ValueChanged<PortfolioSection> onSectionTap;
  final VoidCallback? onMenuTap;

  const Navbar({
    super.key,
    required this.activeSection,
    required this.onSectionTap,
    this.onMenuTap,
  });

  static const double height = 72;

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            color: AppColors.bgGlass,
            border: Border(
              bottom: BorderSide(color: AppColors.borderSubtle),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppSpacing.lg : AppSpacing.huge,
            ),
            child: Row(
              children: [
                const _BrandMark(),
                const Spacer(),
                if (isMobile)
                  _MenuButton(onTap: onMenuTap)
                else
                  _NavLinks(
                    activeSection: activeSection,
                    onSectionTap: onSectionTap,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Portfolio',
      style: AppTextStyles.headingLg.copyWith(fontSize: 20),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _MenuButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
      tooltip: 'Open menu',
    );
  }
}

class _NavLinks extends StatelessWidget {
  final PortfolioSection? activeSection;
  final ValueChanged<PortfolioSection> onSectionTap;

  const _NavLinks({
    required this.activeSection,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final section in PortfolioSection.values)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            child: _NavLink(
              section: section,
              isActive: section == activeSection,
              onTap: () => onSectionTap(section),
            ),
          ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  final PortfolioSection section;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLink({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.isActive || _isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppDurations.base,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.tagBg
                : Colors.transparent,
            borderRadius: AppRadius.pill,
          ),
          child: Text(
            widget.section.label,
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 15,
              color: highlighted
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
