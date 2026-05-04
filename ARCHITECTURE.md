# Architecture

Binding rules are in the **Rules** section. Everything above explains the shape.

The structure follows [Flutter's official app architecture guide](https://docs.flutter.dev/app-architecture/guide), with Cubit replacing ViewModel.

## Layers

```
UI (View + Cubit)  →  Repository  →  Service
```

- **View** — widgets and screens. Reads state from a Cubit, calls Cubit methods.
- **Cubit** — feature state and the methods that change it. Depends on repositories.
- **Repository** — plain class. Orchestrates services. Decides local vs remote, queues writes, merges results. The only thing Cubits talk to.
- **Service** — plain class. Raw I/O against one source (Supabase, Drift, filesystem, Bluetooth). Doesn't know about other services.

Only Cubits hold UI-observable state. Repositories and services are plain classes with methods.

## Cubit scope

**App-wide cubits** are provided once at the app root. State that must outlive any single screen.
- `AuthCubit`, `ConnectivityCubit`, eventually `ThemeCubit` if needed.

**Feature-scoped cubits** are provided at the screen's `BlocProvider` and disposed on pop. State that belongs to one screen flow.
- `DiveLogCubit`, `DiveEditorCubit`, `SiteDetailCubit`, etc.

Decision rule: **does this state need to outlive any single screen?** Yes → app-wide. No → feature-scoped.

Repositories are always app-wide via `RepositoryProvider`. They have no state, only methods.

## Folders — feature-first

```
lib/
  main.dart
  app.dart
  config/
    env.dart
    theme/
    routing/
  core/
    errors/
    extensions/
    utils/
    widgets/
  features/
    <feature>/
      data/
        models/
        services/
        repositories/
      cubit/
        <feature>_cubit.dart
        <feature>_state.dart
      ui/
        screens/
        widgets/
  l10n/
```

Code shared across features goes in `core/` or a dedicated shared feature.

## State

`flutter_bloc` Cubit. State is one immutable class with a `status` enum unless shapes genuinely differ (auth is the canonical sealed-hierarchy case).

Cubits expose intent-named methods (`loadDives()`, `addDive(...)`). No setters, no `BuildContext`. Side effects (navigation, snackbars) are the View's job via `BlocListener`.

## Models

Freezed for models. JSON via `json_serializable`. One model per entity, used as both wire format and domain object. Split into a separate DTO only when Supabase ↔ UI shape actually diverges.

Every persisted entity has `String id` (UUID v4), `DateTime updatedAt`, and `int version`.

## Persistence

Drift is the local DB and the source of truth for offline-first reads. Photos go on disk via `path_provider`; the path is a column. Bytes sync separately to Supabase Storage.

## Sync

Writes go local first and enqueue a pending mutation. A worker drains the queue when online. Conflicts: last-write-wins by server `updatedAt`. IDs are client-generated UUIDs.

## Backend — Supabase

Email/password auth for v1. Anonymous use is allowed except for cloud sync and social. RLS is the source of truth for access control; the client never filters by `user_id`. Env values come from `--dart-define-from-file=config/env/dev.json`. `prod.json` is gitignored.

## Routing — go_router

`go_router` with a hand-written typed-routes file. No codegen. Bottom nav uses `StatefulShellRoute.indexedStack`. Auth-redirect logic lives in `redirect`, reading `AuthCubit`.

## Errors

Services throw. Repositories rethrow or wrap in a `Failure` sealed class (`core/errors/failures.dart`). Cubits catch and emit error states.

## UI

Material 3, dark mode default, `ThemeExtension` for design tokens. Strings go through `flutter_localizations` ARB files (English-only for v1). Stock `Form` + `TextFormField`; shared input widgets in `core/widgets/`.

Numeric measurements are stored in metric. Conversion happens in the View layer only.

## Privacy

- Personal data does not leave the device without opt-in.
- Encyclopedia contributions are anonymous by default.
- Users can export all data and delete their account end-to-end.

## Tooling

`very_good_analysis` with `public_member_api_docs: false` and `lines_longer_than_80_chars: false` relaxed. `lefthook` runs `dart format` and `flutter analyze` on staged files.

---

## Rules

Cited by number in audits.

### Layering
- **R1.** A View never imports from `data/`. Views talk to Cubits only.
- **R2.** A Cubit never imports services directly. Cubits talk to repositories only.
- **R3.** A service never imports another service. Cross-source orchestration is the repository's job.
- **R4.** Imports flow downward: UI → Cubit → Repository → Service.
- **R5.** Repositories and services are plain classes. Only Cubits hold UI-observable state.

### Folders
- **R6.** Feature-first. A feature owns its `data/`, `cubit/`, and `ui/` folders. Cross-feature code lives in `core/` or `config/`.
- **R7.** File names are `snake_case.dart`. Class names are `PascalCase`.

### State
- **R8.** State management is Cubit (`flutter_bloc`). No Riverpod, no Provider package, no setState for cross-widget state.
- **R9.** Each feature has `<feature>_cubit.dart` and `<feature>_state.dart` in `cubit/`.
- **R10.** State is a single class with a `status` enum unless shapes genuinely differ.
- **R11.** Cubits expose intent-named methods. No setters. No `BuildContext`.
- **R12.** Cubits are constructor-injected with their repositories. No service locator.
- **R13.** Cubits holding state that must outlive any single screen are provided once at the app root. Cubits scoped to one screen flow are provided at that screen's `BlocProvider`.

### Models
- **R14.** Models are Freezed unions or data classes with `json_serializable` for serialization.
- **R15.** Every persisted entity has `String id` (UUID v4), `DateTime updatedAt`, and `int version`.
- **R16.** One model per entity until a real Supabase ↔ UI divergence forces a DTO split.

### Persistence & sync
- **R17.** Local DB is Drift. Offline-first features read from Drift first.
- **R18.** Writes go local first and enqueue a pending mutation. Never write to Supabase first.
- **R19.** Conflicts resolve by last-write-wins on server `updatedAt`.
- **R20.** IDs are client-generated UUIDs. Never autoincrement.
- **R21.** Photos live on disk; the path is stored as a column. Bytes sync separately.

### Backend
- **R22.** Auth is Supabase email/password. Anonymous use works for everything except cloud sync and social.
- **R23.** RLS policies are the source of truth for access. The client never filters by `user_id`.
- **R24.** Env values come from `--dart-define-from-file`. No keys in source. `prod.json` is gitignored.

### Routing
- **R25.** `go_router` with a hand-written typed-routes file. No codegen. No string paths in widgets.
- **R26.** Bottom-nav uses `StatefulShellRoute.indexedStack`.

### Errors & logging
- **R27.** Failures are a sealed class in `core/errors/failures.dart`. Cubits emit error states.
- **R28.** Logging uses `dart:developer`'s `log()` until a rule update says otherwise.

### UI
- **R29.** Material 3, dark mode supported, custom `ThemeExtension` for tokens.
- **R30.** User-facing strings go through ARB files, even if English-only.
- **R31.** Shared form widgets live in `core/widgets/`.

### Units & privacy
- **R32.** Measurements are stored in metric. Conversion happens in the View layer only.
- **R33.** Personal data does not leave the device without explicit opt-in. Encyclopedia contributions are anonymous by default.
- **R34.** A user can export all their data and delete their account end-to-end.

### Dependencies
- **R35.** New packages need justification. Conflicts with R8, R14, R17, R25, or R28 require updating this doc first.
- **R36.** No `get_it`, no `provider` package as a locator. DI is constructor injection plus `RepositoryProvider`.

### Process
- **R37.** Features ship end-to-end (model → DB → repository → cubit → UI) before the next feature starts.
- **R38.** Rule changes are recorded in `DECISIONS.md`.