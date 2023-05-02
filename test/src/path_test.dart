// ignore_for_file: inference_failure_on_instance_creation

import 'package:test/test.dart';

import 'package:go_router_paths/src/go_router_paths.dart';

void main() {
  group('goRoute', () {
    test(' "/path" from "path"', () {
      expect(Path('path').goRoute, '/path');
      expect(Path('/path').goRoute, '/path');
      expect(Path('///path').goRoute, '/path');
      expect(Path('path', parent: Path('')).goRoute, '/path');
    });

    test(' "to" from "path/to" with "path" as parent', () {
      expect(Path('to', parent: Path('path')).goRoute, 'to');
    });

    test(' "/path/to" from "path/to"', () {
      expect(Path('path/to').goRoute, '/path/to');
    });

    test(' "/to/some" from "path/to/some" with "path" as parent', () {
      expect(Path('to/some', parent: Path('path')).goRoute, 'to/some');
    });
  });

  group('#path', () {
    test(' "/path" from "path"', () {
      expect(Path('path').path, '/path');
      expect(Path('/path').path, '/path');
      expect(Path('///path').path, '/path');
      expect(Path('path', parent: Path('')).path, '/path');
    });

    test(' "/some/path" from "path" with "some" as parent', () {
      expect(Path('path', parent: Path('some')).path, '/some/path');
    });
  });
}
