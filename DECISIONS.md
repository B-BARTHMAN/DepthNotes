# Decisions

Architectural choices and the reasoning behind them. Add an entry whenever an `ARCHITECTURE.md` rule is added, changed, or removed.

Format: date, decision, why, alternatives.

---

## 2026-05-04 — Follow Flutter's official architecture guide

**Decision:** Layers and responsibilities mirror [docs.flutter.dev/app-architecture/guide](https://docs.flutter.dev/app-architecture/guide). Cubit fills the ViewModel role.

**Why:** Stable reference, well-documented, easy to onboard contributors.

**Alternatives:** Pure Clean Architecture (more ceremony than this project needs); ad-hoc layout (drifts over time).

---

## 2026-05-04 — Cubit over Riverpod / BLoC

**Decision:** State management is `flutter_bloc` Cubit.

**Why:** Codegen-free at the state layer, simpler than full BLoC, consistent shape across features.

**Alternatives:** Riverpod 3 + codegen (more powerful, more magic); BLoC events (more ceremony than this project needs).

---

## 2026-05-04 — Freezed models

**Decision:** Models are Freezed with `json_serializable`.

**Why:** Immutability, `copyWith`, unions, and JSON in one consistent shape with minimal boilerplate. Codegen overhead for models is acceptable.

**Alternatives:** Plain Dart + `equatable` (zero codegen, more verbose); `dart_mappable`.

---

## 2026-05-04 — Drift for local DB

**Decision:** Drift is the local persistence layer.

**Why:** Encyclopedia features are SQL-shaped (date-range filters, joins). Drift gives type-safe SQL with autocomplete.

**Alternatives:** sqflite (raw SQL, fragile); Hive / Isar (NoSQL, wrong fit for relational queries).

---

## 2026-05-04 — Feature-first folders

**Decision:** Top-level `features/<feature>/` with `data/`, `cubit/`, `ui/` inside. `core/` and `config/` for cross-cutting code.

**Why:** Owner preference. Related code stays close. Scales as features grow.

**Alternatives:** Layer-first (`data/`, `logic/`, `ui/` at the top). Cleaner aesthetically; harder to navigate when working on one feature.

---

## 2026-05-04 — UUIDs and version columns from day one

**Decision:** Every entity has a client-generated UUID, `updatedAt`, and `version` from M0.

**Why:** Multi-device sync is a stated goal. Retrofitting means migrating every existing record.

**Alternatives:** Local autoincrement, remap on first sync. Possible but error-prone.

---

## 2026-05-04 — Cloud sync (M2) before sites + map (M4)

**Decision:** Sync ships before the map.

**Why:** The architecture commits to offline-first sync from day one. Proving sync works early de-risks the hardest part.

**Alternatives:** Map first (more visible progress, more wasted work if sync forces schema changes).

---

## 2026-05-04 — go_router without codegen

**Decision:** `go_router` with a hand-written typed-routes file.

**Why:** No codegen, no string sprinkling.

**Alternatives:** `go_router_builder` (typed via codegen); raw paths in widgets.

---

## 2026-05-04 — No service locator

**Decision:** Constructor injection plus `RepositoryProvider`.

**Why:** Dependencies are explicit. One pattern.

**Alternatives:** `get_it` (ergonomic for deep trees, hides dependencies).

---

## 2026-05-17 — DiveTime as a Freezed sealed union

**Decision:** Time data on a dive is a sealed union: `DiveTime.rough` (time of day enum + duration) and `DiveTime.precise` (timeIn + timeOut, duration derived).

**Why:** Prevents invalid states — no timeIn without timeOut, no conflicting duration, no morning enum on a precise entry. Clean upgrade path when dive computer import arrives (rough → precise).

**Alternatives:** Optional nullable fields on Dive (allows inconsistent data); single flat model with validation (runtime errors instead of compile-time safety).

---

## 2026-05-17 — Dive data layer lives in core/

**Decision:** `Dive` model, `DiveRepository`, and `LocalDiveService` live in `core/dive/`, not inside a feature.

**Why:** Dive is the central entity — logbook, editor, statistics, map, and sightings all depend on it. Putting it in one feature creates awkward cross-feature imports.

**Alternatives:** Keep in `features/logbook/data/` (simpler at first, forces a move later when a second feature needs it).

---

## 2026-05-17 — Dive editor is a separate feature from logbook

**Decision:** `features/dive_editor/` is separate from `features/logbook/`. Both share `core/dive/`.

**Why:** The editor will grow significantly (equipment, gas, buddy, conditions). Keeping it separate prevents the logbook feature from bloating.

**Alternatives:** Subfolder inside logbook (simpler but harder to navigate as editor grows).

## 2026-05-17 — Drop per-row `version` column

**Decision:** Entities have `id` and `updatedAt` only. The `version` field
from R15 is removed.

**Why:** R19 resolves conflicts by last-write-wins on server `updatedAt`,
so a per-row revision counter does no work today. `updatedAt` keeps its
job as the conflict resolver — that's why it stays. Adds back cleanly
later if the sync strategy ever needs optimistic concurrency or a
three-way merge base. Supersedes the `version` portion of the
2026-05-04 "UUIDs and version columns from day one" entry; UUIDs and
`updatedAt` from day one still stand.

**Alternatives:** Keep it as future-proofing — costs a column on every
model and a number to remember to increment.