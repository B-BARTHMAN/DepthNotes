This is a directional idea collection. Milestones are loose buckets for thinking, not a checklist. Don't anchor on "what's next in MX."

# Roadmap

No fixed dates. Small, end-to-end milestones. Each ends with a usable app on iOS and Android.

## M0 — Skeleton

Architecture wired, app does nothing useful yet.

- Project on iOS + Android
- `flutter_bloc`, `go_router`, `drift`, `supabase_flutter`, `freezed`, `json_serializable`, `very_good_analysis` installed
- Folder structure from `ARCHITECTURE.md`
- `Env` reading from `--dart-define-from-file`
- M3 theme, dark mode, empty `ThemeExtension`
- `flutter_localizations` + `app_en.arb`
- `lefthook` running format + analyze
- Bottom nav with 3 empty tabs

## M1 — MVP local logbook

Log a dive, see it again. No cloud.

- `Dive` model: id, date, site, depth, time, number, notes
- Drift schema for dives + satellites (no mutation queue — sync is timestamp-tracked later)
- `LocalDiveService`, `DiveRepository` (local-only)
- `DiveLogCubit` with load / add / delete
- Logbook list, dive editor, dive detail screens
- Empty / loading / error states

First version you actually use.

## M2 — Cloud sync

- Supabase project, `dives` table + satellites, RLS
- `SupabaseDiveService`
- `AuthCubit` + email/password
- Sync worker: push/pull rows changed since last sync (`updatedAt`); soft-delete tombstones drain the same way
- Anonymous local logging still works; users can claim local dives by signing up
- Connectivity awareness

## M3 — Photos

- Capture + gallery picker
- Local file path stored on the dive record
- Supabase Storage bucket for bytes
- Sync logic for photos (separate from metadata)

## M4 — Dive sites catalog

Replace free-text site with a real catalog. First slice of the encyclopedia.

- `DiveSite` model, Drift table, Supabase table
- Curated catalog delivered as user-requested regional packs
- Users can create sites locally (client UUID), flagged for curation
- Search + pick a site when logging
- Site detail screen
- Map view

## M5 — Statistics

- Total dives, total bottom time, max depth, deepest, longest
- Dives by month / year
- Sites visited
- Personal records

## M6 — Species sightings

Encyclopedia gets real.

- `Species` catalog (curated, downloadable packs)
- `SpeciesSighting` belongs to a dive; `Abundance` is a rough/exact union
- Logging a sighting when logging a dive
- Species detail: where seen, when, by how many divers (anonymized)
- "My aquarium" — species the user has personally seen

## M7 — Social (directional)

Reverses the original "not a social network" stance — see `DECISIONS.md` and `PROJECT.md`.

- Friends / buddies linked to user accounts (`Buddy.linkedUserId`)
- Standalone posts, optionally linked to one or many dives
- Tagging people
- Keeps privacy-first: opt-in, anonymous use still possible

## Equipment & loadouts (slots into the editor as it grows)

- `Equipment` typed union (exposure suit with thickness, plus generic gear)
- `Loadout` — local quickfill bundling cylinders, equipment, buddies, weight
- Selecting a loadout prefills the editor; the dive snapshots the values

## Beyond (unordered)

- Cosmetic gamification (levels, badges, points)
- Trash-collected and dive highlights
- Trusted-contributor role
- Species / site submission and review flow
- Conditions data (temp, visibility, current) per site per month
- Per-dive gear-usage history (snapshot satellite)
- Unit toggle (metric ↔ imperial)
- Data export (JSON)
- Account deletion
- Dive computer import (multi-channel sample stream; summary unions derive from it)
- Web app
- Research data partnerships

## Working rules

- End-to-end, not horizontal. Model-to-UI before next milestone.
- Always shippable. App is TestFlight-ready at the end of every milestone.
- If a milestone exposes a wrong rule, update `ARCHITECTURE.md` and `DECISIONS.md` before bending it.