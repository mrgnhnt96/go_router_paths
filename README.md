# Go Router Paths

[![codecov](https://codecov.io/gh/mrgnhnt96/go_router_paths/branch/master/graph/badge.svg?token=ZZ4CR3E6HU)](https://codecov.io/gh/mrgnhnt96/go_router_paths)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
<a href="https://github.com/tenhobi/effective_dart"><img src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg" alt="style: effective dart"></a>

## Overview

This package is intended to support, but not limited to, [go_router][go_router].

Go router paths was built out of necessity to remove the need to hard code paths in the application. Use this package to define your paths in one place and use them throughout your application!

## Usage

### Define your paths

```dart
import 'package:go_router_paths/go_router_paths.dart';

class AppPaths {

  static Path get home => Path('home');
  static WelcomePath get welcome => WelcomePath();

  static UsersPath get users => UsersPath();
  static Param<Param> get books => Param('books', 'bookId');
}

class WelcomePath extends Path<WelcomePath> {
    WelcomePath() : super('welcome');

    Path get login => Path('login', parent: this);
    Path get register => Path('register', parent: this);
}

class UsersPath extends Path<UsersPath> {
  UsersPath() : super('users');

  UserPath get user => UserPath(this);
}

class UserPath extends Param<UserPath> {
  UserPath(UsersPath usersPath) : super.only('userId', parent: usersPath);

  Path get edit => Path('edit', parent: this);
  Path get delete => Path('delete', parent: this);
}
```

### Assign your paths to your router

Go router is used in this example, but is not required.

```dart

final routes = GoRouter(
  routes: [
    GoRoute(
      path: AppPaths.home.goRoute, // '/home'
      pageBuilder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppPaths.welcome.goRoute, // '/welcome'
      pageBuilder: (context, state) => const WelcomePage(),
      routes: [
        GoRoute(
          path: AppPaths.welcome.login.goRoute, // 'login'
          pageBuilder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppPaths.welcome.register.goRoute, // 'register'
          pageBuilder: (context, state) => const RegisterPage(),
        ),
      ],
    ),
    GoRoute(
      path: AppPaths.users.goRoute, // '/users'
      pageBuilder: (context, state) => const UsersPage(),
      routes: [
        GoRoute(
          path: AppPaths.users.user.goRoute, // ':userId'
          pageBuilder: (context, state) {
            final userId = state.params[AppPaths.users.user.id]!;

            return UserPage(userId);
          },
          routes: [
            GoRoute(
              path: AppPaths.users.user.edit.goRoute, // 'edit'
              pageBuilder: (context, state) {
                final userId = state.params[AppPaths.users.user.id]!;

                return EditUserPage(userId);
              },
            ),
            GoRoute(
              path: AppPaths.users.user.delete.goRoute, // 'delete'
              pageBuilder: (context, state) {
                final userId = state.params[AppPaths.users.user.id]!;

                return DeleteUserPage(userId);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppPaths.books.goRoute, // '/books/:bookId'
      pageBuilder: (context, state) {
        final bookId = state.params[AppPaths.books.id]!;

        return BookPage(bookId);
      },
    ),
  ],
);
```

### Navigate to your paths

```dart
AppPaths.home.path // '/home'
AppPaths.welcome.login.path // '/welcome/login'
AppPaths.welcome.register.path // '/welcome/register'
AppPaths.users.path // '/users'
AppPaths.users.user.define('Luke Skywalker').path // '/users/Luke%20Skywalker'
AppPaths.users.user.define('Jar Jar binks').edit.path // '/users/Jar%20Jar%20binks/edit'
AppPaths.users.user.define('Darth Vader').delete.path // '/users/Darth%20Vader/delete'
AppPaths.books.define('Star Wars').query({'first-trilogy-only': 'true'}).path // '/books/Star%20Wars?first-trilogy-only=true'
```

## Encoding

All params and query params (keys and values) are encoded using `Uri.encodeComponent`.

[go_router]: https://pub.dev/packages/go_router
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
