part of 'go_router_paths.dart';

/// {@template param}
/// Used to define a route path that requires a parameter
///
/// eg. `/user/:id`
/// {@endtemplate}
class Param<T extends Base<dynamic>> extends Base<T> {
  /// {@macro param}
  Param(
    String path,
    String param, {
    super.parent,
  }) : super(
          path: path,
          param: param,
          params: {},
          queryParameters: {},
        );

  /// To be used to support nested routes of paths
  /// that require a parameter immediately after the parent
  ///
  /// eg. `/users/:id` \
  // ignore: comment_references
  /// where `users` is the [parent] and `id` is the [param]
  Param.only(
    String param, {
    required Base<dynamic> super.parent,
  }) : super(
          path: null,
          param: param,
          params: {},
          queryParameters: {},
        );

  /// the key (id) provided for the [_param]
  String get id {
    return _param!;
  }

  /// defines the parameter for this path's [Param._param]
  T define(String value) {
    final param = _param;

    assert(param != null && param.isNotEmpty, 'param cannot be null or empty');
    _params[param!] = value;

    return this as T;
  }
}
