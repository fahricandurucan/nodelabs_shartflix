import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
                ),
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
              
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.movies.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index == state.movies.length) {
                    // Load more indicator
                    print('🔄 DiscoverPage: Showing load more indicator');
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
                        ),
                      ),
                    );
                  }
                  
                  final movie = state.movies[index];
                  print('🎬 DiscoverPage: Building movie card for index $index: ${movie.title}');
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        // Full Screen Movie Card
                        FullScreenMovieCard(
                          movie: movie,
                          onFavoriteToggle: () {
                            context.read<MoviesBloc>().add(ToggleFavorite(movie.id));
                          },
                        ),
                        
                        // Top Gradient Overlay
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Bottom Gradient Overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Movie Info Overlay (Bottom)
                        Positioned(
                          bottom: 80, // Above navigation bar
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Netflix Logo and Title
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE50914),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'N',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      movie.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Description
                              Text(
                                movie.overview,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Favorite Button (Top Right)
                        Positioned(
                          top: 60,
                          right: 20,
                          child: GestureDetector(
                            onTap: () {
                              context.read<MoviesBloc>().add(ToggleFavorite(movie.id));
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                movie.isFavorite 
                                    ? Icons.favorite 
                                    : Icons.favorite_border,
                                color: movie.isFavorite 
                                    ? const Color(0xFFE50914) 
                                    : Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        
                        // Page Indicator (Top Center)
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${index + 1} / ${state.movies.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0, // Home is selected
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Anasayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              context.go('/profile');
            }
          },
        ),
      ),
    );
  }
} 