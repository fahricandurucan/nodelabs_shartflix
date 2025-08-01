import 'package:flutter/material.dart';
import 'package:nodelabs_shartflix/core/constants/app_colors.dart';

import '../../domain/entities/movie.dart';

class FullScreenMovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onNextMovie;
  final VoidCallback? onPreviousMovie;

  const FullScreenMovieCard({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
    this.onNextMovie,
    this.onPreviousMovie,
  });

  @override
  State<FullScreenMovieCard> createState() => _FullScreenMovieCardState();
}

class _FullScreenMovieCardState extends State<FullScreenMovieCard> {
  bool _isDescriptionExpanded = false;
  double _dragOffset = 0.0;

  String _getImageUrl(String originalUrl) {
    // If URL is empty or null, return placeholder
    if (originalUrl.isEmpty) {
      return 'https://via.placeholder.com/400x800?text=No+Image';
    }
    
    // If it's already HTTPS, return as is
    if (originalUrl.startsWith('https://')) {
      return originalUrl;
    }
    
    // If it's HTTP, try to convert to HTTPS
    if (originalUrl.startsWith('http://')) {
      return originalUrl.replaceFirst('http://', 'https://');
    }
    
    // If it's relative URL, add base URL
    if (originalUrl.startsWith('/')) {
      return 'https://image.tmdb.org/t/p/w500$originalUrl';
    }
    
    return originalUrl;
  }

  @override
  Widget build(BuildContext context) {
    print('poster image = ${widget.movie.posterPath}');
    final imageUrl = _getImageUrl(widget.movie.posterPath);
    print('processed image url = $imageUrl');
    
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dy;
        });
      },
      onVerticalDragEnd: (details) {
        if (_dragOffset < -50 && widget.onNextMovie != null) {
          // Swipe up - go to next movie
          widget.onNextMovie!();
        } else if (_dragOffset > 50 && widget.onPreviousMovie != null) {
          // Swipe down - go to previous movie
          widget.onPreviousMovie!();
        }
        setState(() {
          _dragOffset = 0.0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _dragOffset, 0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                print('Image loading error: $exception');
              },
            ),
          ),
          child: Stack(
            children: [
              // Bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Favorite button (bottom right - Instagram style)
              Positioned(
                bottom: 200, // Above navigation bar
                right: 10,
                child: GestureDetector(
                  onTap: widget.onFavoriteToggle,
                  child: Container(
                    width: 50,
                    height: 80,
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.6),
                      border: Border.all(color: const Color.fromARGB(255, 207, 207, 207).withOpacity(0.5))
                    ),
                    
                    child: Icon(
                      widget.movie.isFavorite 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                      color: widget.movie.isFavorite 
                          ? AppColors.red
                          : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              
              // Movie info at bottom
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Netflix logo and title
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration:  BoxDecoration(
                              color: AppColors.red,
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
                              widget.movie.title,
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
                      // const SizedBox(height: 12),
                      
                      // Movie description with expandable text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.movie.overview,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.4,
                            ),
                            maxLines: _isDescriptionExpanded ? null : 2,
                            overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
                          ),
                          if (!_isDescriptionExpanded && widget.movie.overview.length > 50)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDescriptionExpanded = true;
                                });
                              },
                              child:  Text(
                                'Daha Fazlası',
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (_isDescriptionExpanded)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDescriptionExpanded = false;
                                });
                              },
                              child: Text(
                                'Daha Az',
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 