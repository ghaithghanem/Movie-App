/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/backgroundMSG.png
  AssetGenImage get backgroundMSG =>
      const AssetGenImage('assets/images/backgroundMSG.png');

  /// File path: assets/images/backmg.png
  AssetGenImage get backmg => const AssetGenImage('assets/images/backmg.png');

  /// File path: assets/images/groups.svg
  String get groups => 'assets/images/groups.svg';

  /// File path: assets/images/logo_movie_app.png
  AssetGenImage get logoMovieApp =>
      const AssetGenImage('assets/images/logo_movie_app.png');

  /// File path: assets/images/logo_movie_edit12.png
  AssetGenImage get logoMovieEdit12 =>
      const AssetGenImage('assets/images/logo_movie_edit12.png');

  /// File path: assets/images/message-vocal.png
  AssetGenImage get messageVocal =>
      const AssetGenImage('assets/images/message-vocal.png');

  /// File path: assets/images/movie_app_logo_android12.png
  AssetGenImage get movieAppLogoAndroid12 =>
      const AssetGenImage('assets/images/movie_app_logo_android12.png');

  /// File path: assets/images/notvu.png
  AssetGenImage get notvu => const AssetGenImage('assets/images/notvu.png');

  /// File path: assets/images/person.svg
  String get person => 'assets/images/person.svg';

  /// File path: assets/images/space_backG.jpg
  AssetGenImage get spaceBackG =>
      const AssetGenImage('assets/images/space_backG.jpg');

  /// File path: assets/images/trash_container.png
  AssetGenImage get trashContainer =>
      const AssetGenImage('assets/images/trash_container.png');

  /// File path: assets/images/trash_cover.png
  AssetGenImage get trashCover =>
      const AssetGenImage('assets/images/trash_cover.png');

  /// File path: assets/images/vu.png
  AssetGenImage get vu => const AssetGenImage('assets/images/vu.png');

  /// List of all assets
  List<dynamic> get values => [
        backgroundMSG,
        backmg,
        groups,
        logoMovieApp,
        logoMovieEdit12,
        messageVocal,
        movieAppLogoAndroid12,
        notvu,
        person,
        spaceBackG,
        trashContainer,
        trashCover,
        vu
      ];
}

class Assets {
  Assets._();

  static const String aEnv = '.env';
  static const $AssetsImagesGen images = $AssetsImagesGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
