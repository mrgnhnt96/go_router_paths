part of 'go_router_paths.dart';

/// {@template path}
/// Used to define a route path
///
/// eg. `/user`
/// {@endtemplate}
class Path<T extends Base<dynamic>> extends Base<T> {
  /// {@macro path}
  /// {@macro param}
  Path(
    String path, {
    super.parent,
  }) : super(
          path: path,
          param: null,
          queryParameters: {},
          params: {},
        );
}
