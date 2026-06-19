import '../../features/about/about_injection.dart';
import '../../features/contact/contact_injection.dart';
import '../../features/home/home_injection.dart';
import '../../features/projects/projects_injection.dart';
import '../../features/skills/skills_injection.dart';

/// The only place that wires every feature's dependencies together.
/// Call `setupServiceLocator()` once, from `main()`, before `runApp`.
void setupServiceLocator() {
  registerHomeFeature();
  registerAboutFeature();
  registerSkillsFeature();
  registerProjectsFeature();
  registerContactFeature();
}
