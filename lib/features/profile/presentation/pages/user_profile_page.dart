import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nodelabs_shartflix/core/constants/app_colors.dart';
import 'package:nodelabs_shartflix/features/auth/presentation/widgets/loading_gif_widget.dart';

import '../../../../core/widgets/language_selector.dart';
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

class _UserProfileView extends StatefulWidget {
  @override
  State<_UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<_UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
            onPressed: () {
              context.go('/discover');
            },
          ),
        ),
        title: Text(
          'profile_title'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
                                actions: [
                  LanguageSelector(
                    onLocaleChanged: () => setState(() {}),
                  ),
                                    Container(
                    margin: EdgeInsets.all(8.w),
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
                    child: LimitedOfferBottomSheet(
                      title: 'limited_offer'.tr(),
                      description: 'limited_offer_description'.tr(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.diamond, color: Colors.white, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    'limited_offer'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
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
            print(
                '✅ Profile Page: User authenticated - ${state.user.name} - ${state.user.profileImage}');
            return Column(
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Profile Section
                        Row(
                          children: [
                            // Profile Image
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: state.user.profileImage != null
                                    ? DecorationImage(
                                        image: NetworkImage(state.user.profileImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: state.user.profileImage == null
                                    ? AppColors.red
                                    : null,
                              ),
                              child: state.user.profileImage == null
                                  ? Center(
                                      child: Text(
                                        state.user.name.isNotEmpty
                                            ? state.user.name[0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16.w),

                            // User Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                                              Text(
                              '${'user_id'.tr()}: ${state.user.id}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14.sp,
                              ),
                            ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    state.user.email,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14.sp,
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
                                backgroundColor: AppColors.red,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                                                      child: Text(
                          'add_photo'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Liked Movies Section
                        Text(
                          'favorite_movies'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        BlocBuilder<favorite_bloc.FavoriteMoviesBloc,
                            favorite_bloc.FavoriteMoviesState>(
                          builder: (context, movieState) {
                            if (movieState is favorite_bloc.FavoriteMoviesLoaded) {
                              final favorites = movieState.favoriteMovies;
                              if (favorites.isEmpty) {
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    height: 200.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 60, 60, 60),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Lottie Animation
                                        SizedBox(
                                          height: 100.h,
                                          // decoration: BoxDecoration(
                                          //   color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                                          //   borderRadius: BorderRadius.circular(12),
                                          // ),
                                          child: Image.asset(
                                            'assets/animations/Film.gif',
                                            color: AppColors.red,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              print(error.toString());
                                              return Icon(
                                                Icons.movie_outlined,
                                                color: Colors.grey,
                                                size: 60.sp,
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          'no_favorites'.tr(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'no_favorites_subtitle'.tr(),
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14.sp,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
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
                                              image:
                                                  NetworkImage(getSafeImageUrl(movie.posterPath)),
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
                                height: 200.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Text(
                                    movieState.message,
                                    style:  TextStyle(color: AppColors.red,),
                                  ),
                                ),
                              );
                            } else if (movieState is favorite_bloc.FavoriteMoviesLoading) {
                              return Container(
                                height: 200.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Center(
                                  child: LoadingGifWidget(),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Fixed Logout Button at Bottom
                Container(
                  padding: EdgeInsets.all(24.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF2A2A2A),
                              title: Text(
                                'logout_confirmation_title'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'logout_confirmation_message'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'logout_cancel'.tr(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.read<AuthBloc>().add(LogoutRequested());
                                    context.go('/login');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'logout_confirm'.tr(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'logout'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                'profile_failed'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
