import 'package:depth_notes/config/routing/app_routes.dart';
import 'package:depth_notes/config/routing/shell_scaffold.dart';
import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:depth_notes/features/dive_detail/ui/screens/dive_detail_screen.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_cubit.dart';
import 'package:depth_notes/features/dive_editor/ui/screens/dive_editor_screen.dart';
import 'package:depth_notes/features/explore/ui/screens/explore_screen.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_cubit.dart';
import 'package:depth_notes/features/logbook/ui/screens/logbook_screen.dart';
import 'package:depth_notes/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// App routes.
///
/// Shape:
/// - A bottom-nav shell with three branches (logbook / explore / profile).
/// - Top-level routes for the editor and detail screens, pushed above the
///   shell so the nav bar disappears while logging or viewing.
///
/// Feature-scoped cubits are provided here at the route builder so they
/// live exactly as long as the screen does.
final appRouter = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ShellScaffold(navigationShell: navigationShell),
      branches: [
        // Logbook tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.logbook,
              builder: (context, state) => BlocProvider(
                create: (context) => DiveLogCubit(
                  diveRepository: context.read<DiveRepository>(),
                ),
                child: const LogbookScreen(),
              ),
            ),
          ],
        ),

        // Explore tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),

        // Profile tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Dive editor — pushed above the shell.
    // The Dive (when editing) is passed via `state.extra`.
    GoRoute(
      path: AppRoutes.diveEditor,
      builder: (context, state) {
        final dive = state.extra as Dive?;
        return BlocProvider(
          create: (context) => DiveEditorCubit(
            diveRepository: context.read<DiveRepository>(),
            initialDive: dive,
          ),
          child: DiveEditorScreen(initialDive: dive),
        );
      },
    ),

    // Dive detail.
    // TODO: deep-link crash — `state.extra` is null when arriving by URL.
    // Load by `state.pathParameters['id']` when sharing lands.
    GoRoute(
      path: AppRoutes.diveDetail,
      builder: (context, state) => DiveDetailScreen(dive: state.extra! as Dive),
    ),
  ],
);
