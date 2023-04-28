import 'package:go_router_paths/src/base.dart';

/// {@template param}
/// The base class for all route paths which contain a parameter
/// {@endtemplate}
class Param with Base {
  /// {@macro param}
  const Param();

  @override
  String get goRoute => '';
}
