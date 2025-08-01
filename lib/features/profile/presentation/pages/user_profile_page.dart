import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../movies/domain/repositories/movies_repository.dart';
import '../../../movies/presentation/bloc/favorite_movies_bloc.dart' as favorite_bloc;
import '../../../movies/presentation/widgets/limited_offer_bottom_sheet.dart';

String getSafeImageUrl(String url) {
  if (url.isEmpty) return '';
  if (url.startsWith('http://')) {
    return url.replaceFirst('http://', 'https://');
  }
  return url;
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => favorite_bloc.FavoriteMoviesBloc(
        RepositoryProvider.of<MoviesRepository>(context),
      )..add(favorite_bloc.LoadFavoriteMovies()),
      child: _UserProfileView(),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.go('/discover');
            },
          ),
        ),
        title: const Text(
          'Profil Detayı',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  enableDrag: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const LimitedOfferBottomSheet(
                      title: 'Sınırlı Teklif',
                      description: 'Jeton paketin\'ni seçerek bonus kazanın ve yeni bölümlerin kilidini açın!',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.diamond, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Sınırlı Teklif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          print('🔄 Profile Page: Building with state: ${state.runtimeType}');
          
          if (state is Authenticated) {
            print('✅ Profile Page: User authenticated - ${state.user.name} - ${state.user.profileImage}');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Section
                  Row(
                    children: [
                      // Profile Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: state.user.profileImage != null
                              ? DecorationImage(
                                  image: NetworkImage(state.user.profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: state.user.profileImage == null
                              ? const Color(0xFFE50914)
                              : null,
                        ),
                        child: state.user.profileImage == null
                            ? Center(
                                child: Text(
                                  state.user.name.isNotEmpty
                                      ? state.user.name[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${state.user.id}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.user.email,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Add Photo Button
                      ElevatedButton(
                        onPressed: () {
                          context.go('/photo-upload');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Fotoğraf Ekle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Liked Movies Section
                  const Text(
                    'Beğendiğim Filmler',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<favorite_bloc.FavoriteMoviesBloc, favorite_bloc.FavoriteMoviesState>(
                    builder: (context, movieState) {
                      if (movieState is favorite_bloc.FavoriteMoviesLoaded) {
                        final favorites = movieState.favoriteMovies;
                        if (favorites.isEmpty) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Henüz favori filminiz yok',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final movie = favorites[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                                image: movie.posterPath.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(getSafeImageUrl(movie.posterPath)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: movie.posterPath.isEmpty
                                  ? const Center(
                                      child: Icon(Icons.movie, color: Colors.white, size: 40),
                                    )
                                  : null,
                            );
                          },
                        );
                      } else if (movieState is favorite_bloc.FavoriteMoviesError) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              movieState.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      } else if (movieState is favorite_bloc.FavoriteMoviesLoading) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Çıkış Yap',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Kullanıcı bilgileri yüklenemedi',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
} 