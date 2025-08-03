import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/discover_page.dart';
import '../../features/profile/presentation/pages/photo_upload_page.dart';
import '../../features/profile/presentation/pages/user_profile_page.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)?.locale;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.child,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.currentIndex != 0) {
                  context.go('/discover');
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: widget.currentIndex == 0 ? const Color(0xFFE50914) : Colors.black,
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: widget.currentIndex == 0 ? const Color(0xFFE50914) : Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.currentIndex == 0 ? Icons.home : Icons.home_outlined,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'home'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: widget.currentIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.currentIndex != 1) {
                  context.go('/profile');
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: widget.currentIndex == 1 ? const Color(0xFFE50914) : Colors.black,
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: widget.currentIndex == 1 ? const Color(0xFFE50914) : Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'profile'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: widget.currentIndex == 1 ? FontWeight.w600 : FontWeight.w500,
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

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/discover',
        builder: (context, state) => const MainLayout(
          currentIndex: 0,
          child: DiscoverPage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const MainLayout(
          currentIndex: 1,
          child: UserProfilePage(),
        ),
      ),
      GoRoute(
        path: '/photo-upload',
        builder: (context, state) => const PhotoUploadPage(),
      ),
    ],
  );
} 