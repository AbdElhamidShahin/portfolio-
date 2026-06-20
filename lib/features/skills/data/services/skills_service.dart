import '../models/skill_model.dart';

/// Mock-only data source for the Skills feature.
/// Throws raw exceptions on failure — never catches them itself.
/// [SkillsRepositoryImpl] owns all error mapping.
class SkillsService {
  Future<List<SkillModel>> fetchSkills() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      // ── Frontend & Cross-Platform ─────────────────────────────────────────
      SkillModel(
        id: 's1',
        name: 'Flutter',
        category: 'frontend',
        categoryLabel: 'Frontend & Cross-Platform',
        proficiency: 92,
        description: 'Advanced layouts, custom painters, animations',
      ),
      SkillModel(
        id: 's2',
        name: 'Dart',
        category: 'frontend',
        categoryLabel: 'Frontend & Cross-Platform',
        proficiency: 90,
        description: 'Dart 3+, sealed classes, records, async patterns',
      ),
      SkillModel(
        id: 's3',
        name: 'Flutter Web',
        category: 'frontend',
        categoryLabel: 'Frontend & Cross-Platform',
        proficiency: 80,
        description: 'Responsive SPAs, CanvasKit & HTML renderers',
      ),
      SkillModel(
        id: 's4',
        name: 'Custom Animations',
        category: 'frontend',
        categoryLabel: 'Frontend & Cross-Platform',
        proficiency: 78,
        description: 'AnimationController, Tween, staggered sequences',
      ),

      // ── Architecture & Patterns ───────────────────────────────────────────
      SkillModel(
        id: 's5',
        name: 'Clean Architecture',
        category: 'architecture',
        categoryLabel: 'Architecture & Patterns',
        proficiency: 90,
        description: 'Strict layer separation: presentation → domain → data',
      ),
      SkillModel(
        id: 's6',
        name: 'SOLID Principles',
        category: 'architecture',
        categoryLabel: 'Architecture & Patterns',
        proficiency: 88,
        description: 'Applied across every feature and domain model',
      ),
      SkillModel(
        id: 's7',
        name: 'BLoC / Cubit',
        category: 'architecture',
        categoryLabel: 'Architecture & Patterns',
        proficiency: 92,
        description: 'Sealed state unions, UseCase-driven Cubits',
      ),
      SkillModel(
        id: 's8',
        name: 'Dependency Injection',
        category: 'architecture',
        categoryLabel: 'Architecture & Patterns',
        proficiency: 85,
        description: 'get_it service locator, feature-scoped registrations',
      ),

      // ── Backend & Integrations ─────────────────────────────────────────────
      SkillModel(
        id: 's9',
        name: 'Supabase',
        category: 'backend',
        categoryLabel: 'Backend & Integrations',
        proficiency: 85,
        description: 'Auth, real-time subscriptions, Row Level Security',
      ),
      SkillModel(
        id: 's10',
        name: 'Firebase',
        category: 'backend',
        categoryLabel: 'Backend & Integrations',
        proficiency: 82,
        description: 'Firestore, Auth, Cloud Storage, FCM notifications',
      ),
      SkillModel(
        id: 's11',
        name: 'Stripe',
        category: 'backend',
        categoryLabel: 'Backend & Integrations',
        proficiency: 75,
        description: 'Payment intents, webhooks, mobile checkout flows',
      ),
      SkillModel(
        id: 's12',
        name: 'REST APIs',
        category: 'backend',
        categoryLabel: 'Backend & Integrations',
        proficiency: 88,
        description: 'Dio, interceptors, token refresh, typed responses',
      ),

      // ── DevOps & Tools ────────────────────────────────────────────────────
      SkillModel(
        id: 's13',
        name: 'Git / GitHub',
        category: 'devops',
        categoryLabel: 'DevOps & Tools',
        proficiency: 88,
        description: 'Branching strategies, PR workflows, conflict resolution',
      ),
      SkillModel(
        id: 's14',
        name: 'GitHub Actions',
        category: 'devops',
        categoryLabel: 'DevOps & Tools',
        proficiency: 70,
        description: 'CI pipelines, automated test runs, build artefacts',
      ),
      SkillModel(
        id: 's15',
        name: 'Cursor',
        category: 'devops',
        categoryLabel: 'DevOps & Tools',
        proficiency: 85,
        description: 'AI-assisted development, codebase-aware refactors',
      ),
      SkillModel(
        id: 's16',
        name: 'Claude Code',
        category: 'devops',
        categoryLabel: 'DevOps & Tools',
        proficiency: 82,
        description: 'Agentic coding, architecture reviews, code generation',
      ),
    ];
  }
}
