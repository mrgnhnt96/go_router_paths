part of 'go_router_paths.dart';

/// The mixin for all route paths which contain a query
mixin Query<T> {
  /// adds a query to the path
  T query(Map<String, String> queryParameters);
}
