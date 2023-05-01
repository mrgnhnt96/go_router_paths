// ignore_for_file: strict_raw_type

import 'package:go_router_paths/src/go_router_paths.dart';
import 'package:test/test.dart';

class MultiplePath extends Path<MultiplePath> {
  MultiplePath() : super('home');

  All get all => All(parent: this);
}

class All extends Path<All> {
  All({required super.parent}) : super('all');

  One get one => One(parent: this);
}

class One extends Param<One> {
  One({required super.parent}) : super.only('oneId');

  Path get edit => Path('edit', parent: this);

  Delete get delete => Delete(parent: this);
}

class Delete extends Path<Delete> {
  Delete({required super.parent}) : super('delete');

  Path get all => Path('all', parent: this);
}

void main() {
  test('$MultiplePath', () {
    final paths = MultiplePath();

    expect(paths.goRoute, '/home');
    expect(paths.all.goRoute, 'all');
    expect(paths.all.one.goRoute, ':oneId');

    expect(paths.all.one.id, 'oneId');

    expect(paths.path, '/home');
    expect(paths.all.path, '/home/all');
    expect(paths.all.one.define('one').path, '/home/all/one');
    expect(paths.all.one.define('one').edit.path, '/home/all/one/edit');
    expect(paths.all.one.define('one').delete.path, '/home/all/one/delete');

    expect(
      paths.all.one.define('one').delete.query({'key': 'value'}).all.path,
      '/home/all/one/delete/all?key=value',
    );
    expect(
      paths.all.one.define('one').edit.query({'key': 'value'}).path,
      '/home/all/one/edit?key=value',
    );
    expect(
      paths.all.one.define('one').query({'key': 'value'}).edit.path,
      '/home/all/one/edit?key=value',
    );
  });
}
