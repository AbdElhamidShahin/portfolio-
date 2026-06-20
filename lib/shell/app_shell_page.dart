import 'package:flutter/material.dart';

import '../core/theme/app_breakpoints.dart';
import '../core/theme/app_colors.dart';
import '../features/about/presentation/pages/about_page.dart';
import '../features/contact/presentation/pages/contact_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/projects/presentation/pages/projects_page.dart';
import '../features/skills/presentation/pages/skills_page.dart';
import 'controller/portfolio_section.dart';
import 'controller/section_scroll_controller.dart';
import 'widgets/footer.dart';
import 'widgets/mobile_nav_drawer.dart';
import 'widgets/navbar.dart';

/// The single App Shell for this one-page portfolio.
///
/// Owns the only [Scaffold] and the only top-level scroll view in the
/// app. Every feature page below is a body-only section (no Scaffold,
/// no scroll view of its own) stacked vertically inside it.
class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  // Created once in initState, disposed in dispose — never recreated
  // inside build().
  late final ScrollController _scrollController;
  late final SectionScrollController _sectionScrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PortfolioSection _activeSection = PortfolioSection.home;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _sectionScrollController = SectionScrollController();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final next = _closestSectionToViewportTop();
    if (next != null && next != _activeSection) {
      setState(() => _activeSection = next);
    }
  }

  /// Finds whichever section has most recently scrolled past the top of
  /// the viewport (the section with the largest top-offset that's still
  /// at or above the activation line). Pure read-only geometry lookup —
  /// no rebuilds triggered from here.
  PortfolioSection? _closestSectionToViewportTop() {
    const activationLine = Navbar.height + 80;

    PortfolioSection? closest;
    double bestOffset = double.negativeInfinity;

    for (final section in PortfolioSection.values) {
      final renderObject = _sectionScrollController
          .keyFor(section)
          .currentContext
          ?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) continue;

      final offset = renderObject.localToGlobal(Offset.zero).dy;
      if (offset <= activationLine && offset > bestOffset) {
        bestOffset = offset;
        closest = section;
      }
    }

    return closest;
  }

  void _goToSection(PortfolioSection section) {
    _sectionScrollController.scrollToSection(section);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgBase,
      endDrawer: isMobile
          ? MobileNavDrawer(
              activeSection: _activeSection,
              onSectionTap: _goToSection,
            )
          : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Spacer so content starts below the floating sticky navbar.
                const SizedBox(height: Navbar.height),
                KeyedSubtree(
                  key: _sectionScrollController.keyFor(PortfolioSection.home),
                  child: HomePage(
                    onViewWorkTap: () => _goToSection(PortfolioSection.projects),
                    onContactTap: () => _goToSection(PortfolioSection.contact),
                  ),
                ),
                KeyedSubtree(
                  key:
                      _sectionScrollController.keyFor(PortfolioSection.about),
                  child: const AboutPage(),
                ),
                KeyedSubtree(
                  key: _sectionScrollController
                      .keyFor(PortfolioSection.skills),
                  child: const SkillsPage(),
                ),
                KeyedSubtree(
                  key: _sectionScrollController
                      .keyFor(PortfolioSection.projects),
                  child: const ProjectsPage(),
                ),
                KeyedSubtree(
                  key: _sectionScrollController
                      .keyFor(PortfolioSection.contact),
                  child: const ContactPage(),
                ),
                const Footer(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Navbar(
              activeSection: _activeSection,
              onSectionTap: _goToSection,
              onMenuTap: isMobile
                  ? () => _scaffoldKey.currentState?.openEndDrawer()
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
