# Portfolio — Flutter Web (Clean Architecture)

A feature-first, Clean Architecture Flutter Web project. State management is
Cubit-only, dependency injection is GetIt-only, and there is no code
generation (no `freezed`, no `build_runner`) — Dart 3 sealed classes,
records, and switch expressions are used instead.

## Layers

```
Presentation  →  Domain  →  Data
   (Cubit)      (UseCase)   (Repository / Service / DataSource)
```

Strict rule: **a layer may only depend on the layer directly below it.**

- **Presentation** (`presentation/`) — Cubits, pages, widgets. A Cubit
  depends only on UseCases. Widgets never call a Repository or Service
  directly, and never instantiate anything manually — everything comes
  from GetIt (`sl<T>()`).
- **Domain** (`domain/`) — Entities, abstract Repository contracts,
  UseCases. Pure Dart. No Flutter import. No JSON. This is where
  business rules live.
- **Data** (`data/`) — Models (JSON ↔ Entity), Services (raw API calls),
  DataSources (Service → Model), Repository implementations (DataSource →
  `ApiResult<Entity>`, owns all error mapping).

## Error handling flow

```
Service        → throws raw exceptions (ApiException, SocketException, ...)
DataSource     → lets them propagate (just maps JSON → Model)
RepositoryImpl → catches everything, maps to Failure, returns ApiResult<T>
UseCase        → passes ApiResult<T> straight through
Cubit          → unwraps ApiResult via `.when(success:, failure:)`,
                  maps Failure → a UI-safe String, emits a State
Widget         → renders State only, via switch expression on the
                  sealed ProjectsState
```

`Failure` and `ApiResult<T>` are hand-written sealed classes in
`core/error/` — no codegen involved.

## Folder structure

```
lib/
  core/
    di/            → service_locator.dart, core_injection.dart,
                      injection_container.dart (the only place that
                      wires everything together)
    theme/          → AppColors, AppTypography, AppSpacing/AppRadius, AppTheme
    utils/          → responsive breakpoints, app-wide constants
    widgets/        → shared dumb widgets (loading, error, layout)
    error/          → Failure, ApiResult<T>
    network/        → ApiClient (thin http wrapper), ApiException
  features/
    projects/
      data/
        models/         → ProjectModel (JSON ↔ Entity)
        datasources/    → ProjectsRemoteDataSource(+Impl)
        repositories/   → ProjectsRepositoryImpl
        services/       → ProjectsService (raw API calls)
      domain/
        entities/       → ProjectEntity
        repositories/   → ProjectsRepository (abstract contract)
        usecases/       → GetProjectsUseCase, GetProjectByIdUseCase
      presentation/
        cubit/          → ProjectsCubit, ProjectsState (sealed)
        pages/          → ProjectsPage
        widgets/        → ProjectCard, ProjectsGrid
      projects_injection.dart  → registerProjectsFeature()
```

## Adding a new feature

1. Copy the `features/projects/` folder shape (data/domain/presentation).
2. Define the Entity first, then the Repository contract, then UseCases.
3. Implement the Data layer against that contract.
4. Write the Cubit against the UseCase(s) only.
5. Create a `{feature}_injection.dart` with a `register{Feature}Feature()`
   function, following `projects_injection.dart`.
6. Call it from `core/di/injection_container.dart`.

No other wiring is needed — pages resolve their Cubit via `sl<T>()` inside
a `BlocProvider`, exactly as `ProjectsPage` does.

## Running

```bash
flutter pub get
flutter run -d chrome
```

To point at a real backend:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=https://your-api.com
```

## Testing

```bash
flutter test
```

`test/features/projects/projects_cubit_test.dart` shows the payoff of this
architecture: the Cubit is tested with a fake `ProjectsRepository` — zero
HTTP, zero JSON, zero Flutter widget tree involved.
