import 'package:depth_notes/config/routing/app_routes.dart';
import 'package:depth_notes/config/routing/shell_scaffold.dart';
import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:depth_notes/features/dive_editor/ui/screens/dive_editor_screen.dart';
import 'package:depth_notes/features/explore/ui/screens/explore_screen.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_cubit.dart';
import 'package:depth_notes/features/logbook/ui/screens/logbook_screen.dart';
import 'package:depth_notes/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => 
        ShellScaffold(navigationShell: navigationShell),
      branches: [

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.logbook,
              builder:(context, state) => BlocProvider(
                create: (context) => DiveLogCubit(
                  diveRepository: context.read<DiveRepository>(),
                )..loadDives(),
                child: const LogbookScreen(),
              ),
            )
          ]
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder:(context, state) => const ExploreScreen(),
            )
          ]
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder:(context, state) => const ProfileScreen(),
            )
          ]
        ),

      ]
    ),
    GoRoute(
      path: AppRoutes.diveEditor,
      builder: (context, state) => const DiveEditorScreen(),
    ),
  ]
);
