import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';


import '../../core/components/buttons/bookmark_button.dart';
import '../../core/components/image/base_network_image.dart';

import '../../domain/entities/export_entities.dart';


@RoutePage()
class MovieDetailView extends StatelessWidget {
  const MovieDetailView({super.key, required this.movieDetail, required this.heroTag});

  final MovieDetailEntity? movieDetail;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return  _MovieDetailView(movieDetail: movieDetail, heroTag: heroTag);
  }
}

class _MovieDetailView extends StatelessWidget {
  const _MovieDetailView({required this.movieDetail, required this.heroTag, this.hasRadius = true});

  final MovieDetailEntity? movieDetail;
  final Object heroTag;
  final bool hasRadius;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            //* Appbar
            SliverAppBar(
              expandedHeight: 500,
              collapsedHeight: kToolbarHeight,
              pinned: true,
              actions: [BookmarkButton.filled(movieDetailEntity: movieDetail)],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: hasRadius ? BorderRadius.circular(0) : null,
                    image: movieDetail?.moviePhoto != null
                        ? DecorationImage(
                      image: NetworkImage(movieDetail!.moviePhoto!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: movieDetail?.moviePhoto == null
                      ? Placeholder()
                      : null,
                ),
              ),
            ),


            //* Body
            SliverToBoxAdapter(
              child: SizedBox(
                height: 1.sh - kToolbarHeight - MediaQuery.of(context).padding.top,
                width: 1.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(12).r,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //* Title
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movieDetail?.title ?? '',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                5.verticalSpace,
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        movieDetail?.rate?.toString().substring(0, 3) ?? '',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      5.horizontalSpace,
                                      const Icon(Icons.star, size: 15),
                                      10.horizontalSpace,
                                      Text('·',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(fontWeight: FontWeight.w900)),
                                      10.horizontalSpace,
                                      Text(
                                        movieDetail?.year.toString() ?? '', // Convert the int to a String
                                        style: Theme.of(context).textTheme.titleMedium,
                                      )

                                    ],
                                  ),
                                ),
                              ],
                            ),

                            20.verticalSpace,

                            //* Overview
                            Flexible(child: SingleChildScrollView(child: Text('${movieDetail?.description}'))),

                            20.verticalSpace,

                            //* Backdrop
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: hasRadius ? BorderRadius.circular(0) : null,
                                  image: movieDetail?.moviePhoto != null
                                      ? DecorationImage(
                                    image: NetworkImage(movieDetail!.moviePhoto!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: movieDetail?.moviePhoto == null
                                    ? Placeholder()
                                    : null,
                              ),
                            ),

                            20.verticalSpace,
                          ],
                        ),
                      ),
                    ),



                    20.verticalSpace,
                   /* Container(
        child: Image.asset('assets/logo_movie_app.png'), // Specify your asset image here
      ), */


                    //* Cast
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10).r,
                      child: Text(
                        'Cast',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
