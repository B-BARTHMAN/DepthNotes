abstract final class AppRoutes {
  static const logbook = '/';
  static const explore = '/explore';
  static const profile = '/profile';
  static const diveEditor = '/dive/new';
  static const diveDetail = '/dive/:id';

  static String diveDetailFor(String id) => 'dive/$id';
}
