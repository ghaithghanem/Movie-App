import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/router/app_router.gr.dart';
import '../../core/components/buttons/retry_button.dart';
import '../../core/components/card/movie_card.dart';
import '../../core/components/indicator/base_indicator.dart';
import '../../core/theme/colors/my_colors.dart';
import '../../domain/entities/movie_detail/movie_detail_entity.dart';
import '../_widgets/shimmer/shimmer_loader.dart';
import '../cubit/movie/get_popular_movies/get_popular_movies_cubit.dart';
import '../../domain/entities/export_entities.dart';
part '../_widgets/movies/movie_listing_widget.dart';

@RoutePage()
class MoviesView extends HookWidget {
  const MoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabbarController = useTabController(initialLength: 1); // Adjusted to initialLength: 1

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: tabbarController,
          tabs: const [
            Tab(text: 'Popular'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabbarController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          BlocBuilder<GetPopularMoviesCubit, GetPopularMoviesState>(
            builder: (context, getPopularMoviesState) {
              if (getPopularMoviesState is GetPopularMoviesError) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: RetryButton(
                    text: getPopularMoviesState.message,
                    retryAction: context.read<GetPopularMoviesCubit>().getPopularMovies,
                  ),
                );
              }
              if (getPopularMoviesState is GetPopularMoviesLoading) {
                return ListView.builder(
                  itemCount: 10, // Number of shimmer items to show
                  itemBuilder: (_, index) => Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: Theme.of(context).highlightColor.withOpacity(0.5),
                    highlightColor: MyColors.backgroundGey.withOpacity(0.04),
                    enabled: true,
                    child:MovieShimmer(),
                  ),
                );
              } else
              if (getPopularMoviesState is GetPopularMoviesLoaded) {
                return _MovieListingWidget(
                  hasReachedMax: context.watch<GetPopularMoviesCubit>().hasReachedMax,
                  movies: getPopularMoviesState.movies,
                  whenScrollBottom: () async => context.read<GetPopularMoviesCubit>().getPopularMovies(),
                  onRefresh: () async {
                    print('Refreshing movies'); // Debug logging
                    // Optionally, clear the current movies before fetching new ones
                    await context.read<GetPopularMoviesCubit>()..refreshPopularMovies();
                  },
                );
              }


              return const BaseIndicator();
            },
          ),
        ],
      ),
    );
  }
}



