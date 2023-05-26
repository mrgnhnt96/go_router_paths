part of 'go_router_paths.dart';

/// {@template base}
/// The base class for all route paths
/// {@endtemplate}
abstract class Base<T extends Base<dynamic>> with Query<T> {
  /// {@macro base}
  const Base({
    required String? path,
    required String? param,
    required Base<dynamic>? parent,
    required Map<String, String> queryParameters,
    required Map<String, String> params,
  })  : _path = path,
        _param = param,
        _parent = parent,
        _params = params,
        _queryParameters = queryParameters;

  /// the only time that that path is null is when
  /// there is a param immediately after the parent
  ///
  /// eg. `/users/:id`\
  /// where `/users` is the parent and `:id` is the param provided
  final String? _path;
  final String? _param;
  final Base<dynamic>? _parent;
  final Map<String, String> _queryParameters;
  final Map<String, String> _params;

  Iterable<String> get _segments sync* {
    final parent = _parent;
    if (parent != null) {
      final segments = parent._segments;

      if (segments.isNotEmpty) {
        yield* segments;
      }
    }

    final path = _path;
    if (path != null && path.isNotEmpty) {
      final segments = _split(path);

      if (segments.isNotEmpty) {
        yield* segments;
      }
    }

    final param = _param;
    if (param != null && param.isNotEmpty) {
      yield ':$param';
    }
  }

  Map<String, String> get _allParams {
    final params = <String, String>{};

    void paramsFrom(Base<dynamic> base) {
      params.addAll(base._params);

      if (base._parent != null) {
        params.addAll(base._parent!._params);
        paramsFrom(base._parent!);
      }
    }

    paramsFrom(this);

    return params;
  }

  Map<String, String> get _allQueryParameters {
    final queries = <String, String>{};

    void queriesFrom(Base<dynamic> base) {
      queries.addAll(base._queryParameters);

      if (base._parent != null) {
        queries.addAll(base._parent!._queryParameters);
        queriesFrom(base._parent!);
      }
    }

    queriesFrom(this);

    return queries;
  }

  /// the path used to navigate to the route
  /// associated with this path
  String get path {
    final segments = _segments.toList();

    final params = _allParams;

    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];

      if (!segment.startsWith(':')) {
        continue;
      }

      final id = segment.substring(1);

      if (!params.containsKey(id)) {
        throw Exception(
          'No parameter defined for path: ${segments.join('/')}',
        );
      }

      segments[i] = Uri.encodeComponent(params[id]!);
    }

    final queries = _allQueryParameters;

    final query = StringBuffer();

    if (queries.isNotEmpty) {
      query.write('?');
    }

    for (var i = 0; i < queries.entries.length; i++) {
      final entry = queries.entries.elementAt(i);

      query
        ..write(Uri.encodeComponent(entry.key))
        ..write('=')
        ..write(Uri.encodeComponent(entry.value));

      if (i != queries.entries.length - 1) {
        query.write('&');
      }
    }

    return '/${segments.join('/')}$query';
  }

  List<String> _split(String path) {
    final clean = _clean(path);

    final segments = clean.split('/')..removeWhere((e) => e.isEmpty);

    return segments;
  }

  String _clean(String path) {
    var clean = path;

    final patterns = {
      RegExp(r'^\/*'): '',
      RegExp(r'\/\/*'): '/',
    };

    for (final pattern in patterns.entries) {
      clean = clean.replaceAll(pattern.key, pattern.value);
    }

    return clean;
  }

  @override
  T query(Map<String, String> queryParameters) {
    _queryParameters.addAll(queryParameters);

    return this as T;
  }

  /// the path to be used for `GoRoute.path`
  String get goRoute {
    final path = _path;
    if (path == null) {
      final param = _param;
      assert(param != null, 'Param cannot be null when path is null');

      if (!RegExp(r'^\w+$').hasMatch(param!)) {
        throw ArgumentError(
          'Param must be alphanumeric and cannot contain special characters',
        );
      }

      return ':$param';
    }

    final cleanPath = _clean(path);

    final parent = _parent;
    var start = '/';
    if (parent != null && parent._segments.isNotEmpty) {
      start = '';
    }

    var param = '';
    if (_param != null) {
      param = '/:$_param';
    }

    return '$start$cleanPath$param';
  }
}
