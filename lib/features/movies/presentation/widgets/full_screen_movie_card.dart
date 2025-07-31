import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

class FullScreenMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onFavoriteToggle;

  const FullScreenMovieCard({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
  });

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
    print('poster image = ${movie.posterPath}');
    final imageUrl = _getImageUrl(movie.posterPath);
    print('processed image url = $imageUrl');
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            print('Image loading error: $exception');
            // Handle image loading error
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Section - Status Bar Area
              const SizedBox(height: 20),
              
              // Middle Section - Main Content
              Expanded(
                child: Container(),
              ),
              
              // Bottom Section - Movie Info
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Title
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    
                    // Movie Details Row
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50914),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Genres
                        if (movie.genres.isNotEmpty)
                          Expanded(
                            child: Text(
                              movie.genres.take(2).join(', '),
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Movie Description
                    Text(
                      movie.overview,
                      style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 16,
                        height: 1.4,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    
                    // Action Buttons
                    Row(
                      children: [
                        // Play Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Play movie
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE50914),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow, color: Colors.white),
                            label: const Text(
                              'İzle',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // More Info Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade600),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // TODO: Show more info
                            },
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 