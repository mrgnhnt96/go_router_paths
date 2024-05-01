import 'package:go_router_paths/go_router_paths.dart';

// Define the paths for your app
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

// Define the routes for your app
final routes = GoRouter(
  routes: [
    GoRoute(
      path: AppPaths.home.goRoute,
      pageBuilder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppPaths.welcome.goRoute,
      pageBuilder: (context, state) => const WelcomePage(),
      routes: [
        GoRoute(
          path: AppPaths.welcome.login.goRoute,
          pageBuilder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppPaths.welcome.register.goRoute,
          pageBuilder: (context, state) => const RegisterPage(),
        ),
      ],
    ),
    GoRoute(
      path: AppPaths.users.goRoute,
      pageBuilder: (context, state) => const UsersPage(),
      routes: [
        GoRoute(
          path: AppPaths.users.user.goRoute,
          pageBuilder: (context, state) {
            final userId = state.params[AppPaths.users.user.id]!;

            return UserPage(userId);
          },
          routes: [
            GoRoute(
              path: AppPaths.users.user.edit.goRoute,
              pageBuilder: (context, state) {
                final userId = state.params[AppPaths.users.user.id]!;

                return EditUserPage(userId);
              },
            ),
            GoRoute(
              path: AppPaths.users.user.delete.goRoute,
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
      path: AppPaths.books.goRoute,
      pageBuilder: (context, state) {
        final bookId = state.params[AppPaths.books.id]!;

        return BookPage(bookId);
      },
    ),
  ],
);

// Use the routes in your app
void main() {
  AppPaths.home.path; // '/home'
  AppPaths.welcome.login.path; // '/welcome/login'
  AppPaths.welcome.register.path; // '/welcome/register'
  AppPaths.users.path; // '/users'
  AppPaths.users.user.define('Luke Skywalker').path; // '/users/Luke Skywalker'
  AppPaths.users.user
      .define('Jar Jar binks')
      .edit
      .path; // '/users/Jar Jar binks/edit'
  AppPaths.users.user
      .define('Darth Vader')
      .delete
      .path; // '/users/Darth Vader/delete'
  AppPaths.books.define('Star Wars').query({
    'first-trilogy-only': 'true'
  }).path; // '/books/Star Wars?first-trilogy-only=true'
}
