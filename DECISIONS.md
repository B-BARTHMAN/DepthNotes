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

---

## 2026-05-25 — IDs are UUID v7

**Decision:** Client-generated IDs are UUID **v7**, matching the code (`Uuid().v7()`). R15 reworded from v4 to v7.

**Why:** v7 is time-ordered, so it doubles as a natural insertion-order sort and indexes better than v4. Clarifies the 2026-05-04 / 2026-05-17 UUID entries.

**Alternatives:** v4 (random, no ordering); ULID (same idea, extra dependency).

---

## 2026-05-25 — Change-tracked sync; drop the mutation queue

**Decision:** No `PendingMutation` queue. The sync worker pushes local rows where `updatedAt > lastSync` and pulls remote rows the same way; conflicts resolve last-write-wins on `updatedAt`. R18 rewritten.

**Why:** With `updatedAt` + `deletedAt` on every syncable row, a queue does no work a timestamp scan can't. Removes an entity and a whole class of queue-drain bugs.

**Alternatives:** Op-log queue (precise ordering + per-op retries — neither needed for a logbook).

---

## 2026-05-25 — Soft delete via `deletedAt`

**Decision:** Syncable entities carry `deletedAt`. Deleting sets it and bumps `updatedAt`. New rule R41.

**Why:** Under last-write-wins, a hard delete leaves no trace, so another device's stale copy upserts the row back ("resurrection"). A tombstone makes the delete a normal newest-wins write that propagates everywhere.

**Alternatives:** Hard delete (resurrection bug); a separate tombstones table (an extra table + join for no real gain over one nullable column).

---

## 2026-05-25 — Logbook entities snapshot facts; loadouts only prefill

**Decision:** A dive copies its gear/gas/conditions in at log time. It never references a loadout (or any local-only record) by id. New rule R40; loadout drops off the `Dive` model.

**Why:** A log must freeze what actually happened — editing or deleting a loadout must not rewrite past dives. And since loadouts are local-only while dives sync, a reference couldn't cross the boundary anyway.

**Alternatives:** Live `loadoutId` on the dive (corrupts history on edit; breaks on a second device).

---

## 2026-05-25 — Equipment and loadouts are local-only

**Decision:** `Equipment` and `Loadout` live only on the device; they don't sync. New rule R42. Synced data is dives + satellites, profile, and catalog.

**Why:** They're entry-convenience config, not contributions. Keeping them off the wire is simpler and matches privacy-first. The dive already snapshots what it needs.

**Alternatives:** Sync them as private user data (nice for multi-device; revisit when that's a real need).

---

## 2026-05-25 — User-created sites and downloadable packs

**Decision:** The catalog (sites, species) ships as user-requested regional packs read offline. Users may create dive sites locally with a client UUID, flagged for curation. New rule R43; M4 "read-only for end users" dropped.

**Why:** Offline-first means a diver at an uncatalogued site must still log it. Local creation + later curation fits the trusted-contributor vision.

**Alternatives:** Strictly read-only catalog (can't log a new site offline); free-text site label only (no atlas geo for new places).

---

## 2026-05-25 — Variable-fidelity unions extended

**Decision:** The `DiveTime` rough/precise pattern generalizes (R39): `Temperature` (rough/single/range), `Visibility` (rough/exact), `Abundance` (rough/exact), and `Equipment` (per-type variants — `exposureSuit` carries thickness, `generic` carries a category).

**Why:** The same real quantity is entered at different fidelities (eyeballed bucket vs measured number). A union keeps each shape valid and lets coarse derive from fine; `Equipment` gets type-specific fields without a wall of nullables.

**Alternatives:** Flat models with nullable type/fidelity-specific fields (allows contradictory states, validated only at runtime).

---

## 2026-05-25 — Optional social layer (buddies + standalone posts)

**Decision:** Add an optional, secondary social layer — friends/buddies linked to accounts, and standalone posts that may link to zero-or-many dives. The product stays dive-first; social never becomes the point.

**Why:** Light social without pivoting away from the logbook/encyclopedia. Posts are ordinary syncable entities (local-first, timestamp sync, soft delete), so offline works with no special handling. Hooks exist now (`Buddy.linkedUserId`, `Profile`); `Users` and `Post` land in the social milestone.

**Note:** Updates `PROJECT.md` — principle 3 now reads "dives are the core… social is secondary," and "What it's not" softens from "no standalone posts" to "not primarily a social network."

**Alternatives:** Dive-anchored-only social (posts must attach to a dive); no social at all (the original stance).