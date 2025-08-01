import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs_shartflix/features/auth/presentation/widgets/loading_gif_widget.dart';

import '../../../movies/presentation/bloc/movies_bloc.dart';
import '../../../movies/presentation/widgets/full_screen_movie_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Load initial movies
    print('🎬 DiscoverPage: Initializing - loading first page');
    context.read<MoviesBloc>().add(const LoadMovies());
    
    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) {
      print('⏳ DiscoverPage: Already loading more, skipping...');
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<MoviesBloc>().state;
      if (state is MoviesLoaded && !state.hasReachedMax) {
        print('📜 DiscoverPage: Near end of scroll - loading page ${state.currentPage + 1}');
        print('📊 DiscoverPage: Current movies count: ${state.movies.length}');
        
        setState(() {
          _isLoadingMore = true;
        });
        
        context.read<MoviesBloc>().add(LoadMovies(page: state.currentPage + 1));
      } else if (state is MoviesLoaded && state.hasReachedMax) {
        print('🏁 DiscoverPage: Reached max movies - no more loading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesBloc = context.read<MoviesBloc>();
    final state = moviesBloc.state;
    if (state is! MoviesLoaded && state is! MoviesLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        moviesBloc.add(const LoadMovies());
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<MoviesBloc, MoviesState>(
        listener: (context, state) {
          if (state is MoviesLoaded) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        },
        child: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
            print('🎬 DiscoverPage: Building with state: ${state.runtimeType}');
            
            if (state is MoviesLoading) {
              print('🔄 DiscoverPage: Showing loading indicator');
              return const Center(
                child: LoadingGifWidget()
              );
            } else if (state is MoviesLoaded) {
              print('📦 DiscoverPage: Showing ${state.movies.length} movies (page ${state.currentPage})');
              if (state.movies.isEmpty) {
                return const Center(
                  child: Text(
                    'Henüz film bulunamadı',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MoviesBloc>().add(RefreshMovies());
                },
                color: const Color(0xFFE50914),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.movies.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == state.movies.length) {
                      // Load more indicator
                      print('🔄 DiscoverPage: Showing load more indicator');
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: LoadingGifWidget(color:Color(0xFFE50914),)
                        ),
                      );
                    }
                    
                    final movie = state.movies[index];
                    print('🎬 DiscoverPage: Building movie card for index $index: ${movie.title} - ${movie.isFavorite}');
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: FullScreenMovieCard(
                        movie: movie,
                        onFavoriteToggle: () {
                          context.read<MoviesBloc>().add(ToggleFavorite(movie.id));
                        },
                        onNextMovie: () {
                          if (index < state.movies.length - 1) {
                            _scrollController.animateTo(
                              (index + 1) * MediaQuery.of(context).size.height,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        onPreviousMovie: () {
                          if (index > 0) {
                            _scrollController.animateTo(
                              (index - 1) * MediaQuery.of(context).size.height,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (state is MoviesError) {
              print('❌ DiscoverPage: Showing error: ${state.message}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hata: ${state.message}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MoviesBloc>().add(const LoadMovies());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50914),
                      ),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }
            
            return const Center(
              child: Text(
                'Film bulunamadı',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),

    );
  }
} 