// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/foundation.dart' as _i17;
import 'package:flutter/material.dart' as _i16;
import 'package:movie_app/src/config/router/check_auth_route.dart' as _i4;
import 'package:movie_app/src/domain/entities/export_entities.dart' as _i18;
import 'package:movie_app/src/presentation/_widgets/image_picker/camera_widget.dart'
    as _i2;
import 'package:movie_app/src/presentation/view/auth/signin/signin_view.dart'
    as _i12;
import 'package:movie_app/src/presentation/view/auth/signin/signup_view.dart'
    as _i13;
import 'package:movie_app/src/presentation/view/bookmarks_view.dart' as _i1;
import 'package:movie_app/src/presentation/view/camera_view/camera_view.dart'
    as _i3;
import 'package:movie_app/src/presentation/view/camera_view/video_view.dart'
    as _i14;
import 'package:movie_app/src/presentation/view/master_view.dart' as _i8;
import 'package:movie_app/src/presentation/view/message_view/conversation_view.dart'
    as _i5;
import 'package:movie_app/src/presentation/view/message_view/create_groupe_view.dart'
    as _i6;
import 'package:movie_app/src/presentation/view/message_view/get_messages_view.dart'
    as _i7;
import 'package:movie_app/src/presentation/view/message_view/select_contact_view.dart'
    as _i11;
import 'package:movie_app/src/presentation/view/movie_detail_view.dart' as _i9;
import 'package:movie_app/src/presentation/view/movies_view.dart' as _i10;

abstract class $AppRouter extends _i15.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    BookmarksRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.BookmarksView(),
      );
    },
    CameraScreenRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.CameraScreen(),
      );
    },
    CameraRoutePage.name: (routeData) {
      final args = routeData.argsAs<CameraRoutePageArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.CameraViewPage(
          key: args.key,
          path: args.path,
        ),
      );
    },
    CheckAuthRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.CheckAuthRoute(),
      );
    },
    ConversationRoute.name: (routeData) {
      final args = routeData.argsAs<ConversationRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ConversationView(
          key: args.key,
          messageDetail: args.messageDetail,
          heroTag: args.heroTag,
        ),
      );
    },
    CreateGroupeRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.CreateGroupeView(),
      );
    },
    GetMessagesRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.GetMessagesView(),
      );
    },
    MasterRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MasterView(),
      );
    },
    MovieDetailRoute.name: (routeData) {
      final args = routeData.argsAs<MovieDetailRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.MovieDetailView(
          key: args.key,
          movieDetail: args.movieDetail,
          heroTag: args.heroTag,
        ),
      );
    },
    MoviesRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.MoviesView(),
      );
    },
    SelectContactRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SelectContactView(),
      );
    },
    SigninRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SigninView(),
      );
    },
    SignupRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SignupView(),
      );
    },
    VideoRoutePage.name: (routeData) {
      final args = routeData.argsAs<VideoRoutePageArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.VideoViewPage(
          key: args.key,
          path: args.path,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.BookmarksView]
class BookmarksRoute extends _i15.PageRouteInfo<void> {
  const BookmarksRoute({List<_i15.PageRouteInfo>? children})
      : super(
          BookmarksRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookmarksRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i2.CameraScreenRoute]
class CameraScreenRoute extends _i15.PageRouteInfo<void> {
  const CameraScreenRoute({List<_i15.PageRouteInfo>? children})
      : super(
          CameraScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'CameraScreen';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CameraViewPage]
class CameraRoutePage extends _i15.PageRouteInfo<CameraRoutePageArgs> {
  CameraRoutePage({
    _i16.Key? key,
    required String path,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          CameraRoutePage.name,
          args: CameraRoutePageArgs(
            key: key,
            path: path,
          ),
          initialChildren: children,
        );

  static const String name = 'CameraRoutePage';

  static const _i15.PageInfo<CameraRoutePageArgs> page =
      _i15.PageInfo<CameraRoutePageArgs>(name);
}

class CameraRoutePageArgs {
  const CameraRoutePageArgs({
    this.key,
    required this.path,
  });

  final _i16.Key? key;

  final String path;

  @override
  String toString() {
    return 'CameraRoutePageArgs{key: $key, path: $path}';
  }
}

/// generated route for
/// [_i4.CheckAuthRoute]
class CheckAuthRoute extends _i15.PageRouteInfo<void> {
  const CheckAuthRoute({List<_i15.PageRouteInfo>? children})
      : super(
          CheckAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'CheckAuthRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ConversationView]
class ConversationRoute extends _i15.PageRouteInfo<ConversationRouteArgs> {
  ConversationRoute({
    _i17.Key? key,
    required _i18.MessageEntity? messageDetail,
    required Object heroTag,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ConversationRoute.name,
          args: ConversationRouteArgs(
            key: key,
            messageDetail: messageDetail,
            heroTag: heroTag,
          ),
          initialChildren: children,
        );

  static const String name = 'ConversationRoute';

  static const _i15.PageInfo<ConversationRouteArgs> page =
      _i15.PageInfo<ConversationRouteArgs>(name);
}

class ConversationRouteArgs {
  const ConversationRouteArgs({
    this.key,
    required this.messageDetail,
    required this.heroTag,
  });

  final _i17.Key? key;

  final _i18.MessageEntity? messageDetail;

  final Object heroTag;

  @override
  String toString() {
    return 'ConversationRouteArgs{key: $key, messageDetail: $messageDetail, heroTag: $heroTag}';
  }
}

/// generated route for
/// [_i6.CreateGroupeView]
class CreateGroupeRoute extends _i15.PageRouteInfo<void> {
  const CreateGroupeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          CreateGroupeRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateGroupeRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i7.GetMessagesView]
class GetMessagesRoute extends _i15.PageRouteInfo<void> {
  const GetMessagesRoute({List<_i15.PageRouteInfo>? children})
      : super(
          GetMessagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'GetMessagesRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MasterView]
class MasterRoute extends _i15.PageRouteInfo<void> {
  const MasterRoute({List<_i15.PageRouteInfo>? children})
      : super(
          MasterRoute.name,
          initialChildren: children,
        );

  static const String name = 'MasterRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MovieDetailView]
class MovieDetailRoute extends _i15.PageRouteInfo<MovieDetailRouteArgs> {
  MovieDetailRoute({
    _i16.Key? key,
    required _i18.MovieDetailEntity? movieDetail,
    required Object heroTag,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          MovieDetailRoute.name,
          args: MovieDetailRouteArgs(
            key: key,
            movieDetail: movieDetail,
            heroTag: heroTag,
          ),
          initialChildren: children,
        );

  static const String name = 'MovieDetailRoute';

  static const _i15.PageInfo<MovieDetailRouteArgs> page =
      _i15.PageInfo<MovieDetailRouteArgs>(name);
}

class MovieDetailRouteArgs {
  const MovieDetailRouteArgs({
    this.key,
    required this.movieDetail,
    required this.heroTag,
  });

  final _i16.Key? key;

  final _i18.MovieDetailEntity? movieDetail;

  final Object heroTag;

  @override
  String toString() {
    return 'MovieDetailRouteArgs{key: $key, movieDetail: $movieDetail, heroTag: $heroTag}';
  }
}

/// generated route for
/// [_i10.MoviesView]
class MoviesRoute extends _i15.PageRouteInfo<void> {
  const MoviesRoute({List<_i15.PageRouteInfo>? children})
      : super(
          MoviesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MoviesRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SelectContactView]
class SelectContactRoute extends _i15.PageRouteInfo<void> {
  const SelectContactRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SelectContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectContactRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SigninView]
class SigninRoute extends _i15.PageRouteInfo<void> {
  const SigninRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SigninRoute.name,
          initialChildren: children,
        );

  static const String name = 'SigninRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SignupView]
class SignupRoute extends _i15.PageRouteInfo<void> {
  const SignupRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i14.VideoViewPage]
class VideoRoutePage extends _i15.PageRouteInfo<VideoRoutePageArgs> {
  VideoRoutePage({
    _i16.Key? key,
    required String path,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          VideoRoutePage.name,
          args: VideoRoutePageArgs(
            key: key,
            path: path,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoRoutePage';

  static const _i15.PageInfo<VideoRoutePageArgs> page =
      _i15.PageInfo<VideoRoutePageArgs>(name);
}

class VideoRoutePageArgs {
  const VideoRoutePageArgs({
    this.key,
    required this.path,
  });

  final _i16.Key? key;

  final String path;

  @override
  String toString() {
    return 'VideoRoutePageArgs{key: $key, path: $path}';
  }
}
