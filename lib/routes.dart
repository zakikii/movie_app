import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zaki_movie_apps/Screens/LoginScreen.dart';
import 'package:zaki_movie_apps/Screens/MainScreen.dart';
import 'package:zaki_movie_apps/Screens/MovieScreen.dart';
import 'package:zaki_movie_apps/Screens/NavScreen.dart';
import 'package:zaki_movie_apps/Screens/ProfileScreen.dart';
import 'package:zaki_movie_apps/Screens/SearchScreen.dart';
import 'package:zaki_movie_apps/Screens/TvShowScreen.dart';
import 'package:zaki_movie_apps/Screens/disconnect.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/disconnect',
    builder: (context, state) => const Disconnected(),
  ),
  GoRoute(
    path: '/',
    builder: (context, state) => const NavScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
    pageBuilder: defaultPageBuilder<LoginScreen>(const LoginScreen()),
  ),
  GoRoute(
    path: '/main',
    builder: (context, state) => const MainScreen(),
    pageBuilder: defaultPageBuilder<MainScreen>(const MainScreen()),
  ),
  GoRoute(
    path: '/search',
    builder: (context, state) => const SearchScreen(),
    pageBuilder: defaultPageBuilder<SearchScreen>(const SearchScreen()),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfileScreen(),
    pageBuilder: defaultPageBuilder<ProfileScreen>(const ProfileScreen()),
  ),
  GoRoute(
    path: '/movie/:id',
    builder: (context, state) => MovieScreen(state.params['id']!),
  ),
  GoRoute(
    path: '/tv/:id',
    builder: (context, state) => TVShowScreen(state.params['id']!),
  )
]);

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
        Widget child) =>
    (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };
