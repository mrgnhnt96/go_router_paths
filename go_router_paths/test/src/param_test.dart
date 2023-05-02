// ignore_for_file: inference_failure_on_instance_creation

import 'package:go_router_paths/src/go_router_paths.dart';
import 'package:test/test.dart';

void main() {
  group('goRoute', () {
    test(' "path/:id" from "path/:id"', () {
      expect(Param('path/:id', 'id').goRoute, '/path/:id');
    });

    test(' "path/:id" from "path/:id" with parent "some"', () {
      expect(
        Param('path/:id', 'id', parent: Path('some')).goRoute,
        'path/:id',
      );
    });

    test(' ":id" from "path/:id" with parent "some"', () {
      expect(
        Param.only('id', parent: Path('some')).goRoute,
        ':id',
      );
    });
  });

  group('#path', () {
    test(' "path/hello" from "path/:id"', () {
      expect(Param('path', 'id').define('hello').path, '/path/hello');
    });

    test(' "paths/one" from "paths/:id" where "paths" is parent', () {
      expect(
        Param.only(':id', parent: Path('paths')).define('one').path,
        '/paths/one',
      );
    });
  });

  test('#id returns "oneId"', () {
    expect(Param('all', 'oneId').id, 'oneId');
  });
}