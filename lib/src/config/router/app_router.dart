import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/constants/path_constants.dart';
import 'app_router.gr.dart';



@AutoRouterConfig(replaceInRouteName: 'View|Widget,Route')

/// Holds all the routes that are defined in the app
/// Used to generate the Router object
final class AppRouter extends $AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
    AdaptiveRoute(
      page: CheckAuthRoute.page,
      path: PathConstants.check_auth_route ,
      initial: true,
    ),
    AdaptiveRoute(
      page: SigninRoute.page,
      path: PathConstants.signin,
      //initial: true,
    ),
    AdaptiveRoute(
      page: MasterRoute.page,
      path: PathConstants.master,
      children: [
        AdaptiveRoute(
          page: MoviesRoute.page,
          path: PathConstants.movies,
          title: (_, __) => 'Movies',
        ),
        AdaptiveRoute(
          page: BookmarksRoute.page,
          path: PathConstants.bookmarks,
          title: (_, __) => 'Bookmarks',
        ),
        AdaptiveRoute(
          page: GetMessagesRoute.page,
          path: PathConstants.messages,
          title: (_, __) => 'messages',
        ),
      ],
    ),
    AdaptiveRoute(
      page: SignupRoute.page,
      path: PathConstants.signup,
      //title: (_, __) => 'Movies',
    ),
    AdaptiveRoute(
      page: SelectContactRoute.page,
      path: PathConstants.selectItem,
      //title: (_, __) => 'Movies',
    ),
    AdaptiveRoute(
      page: CreateGroupeRoute.page,
      path: PathConstants.createGroupe,
      //title: (_, __) => 'Movies',
    ),
    AdaptiveRoute(
      page: ConversationRoute.page,
      path: PathConstants.conversation,
      //title: (_, __) => 'Movies',
    ),
    CustomRoute(
      page: MovieDetailRoute.page,
      path: PathConstants.movieDetail,
      durationInMilliseconds: 800,
      reverseDurationInMilliseconds: 800,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  ];
}