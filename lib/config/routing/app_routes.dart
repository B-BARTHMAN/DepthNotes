/// Centralized route paths. Widgets push by reference, never by string
abstract final class AppRoutes {
  static const logbook = '/';
  static const explore = '/explore';
  static const profile = '/profile';
  static const diveEditor = '/dive/new';
  static const diveDetail = '/dive/:id';

  /// Concrete path for a specific dive.
  static String diveDetailFor(String id) => '/dive/$id';
}
