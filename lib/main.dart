import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/app_router.dart';
import 'core/services/api_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/movies/data/repositories/movies_repository_impl.dart';
import 'features/movies/domain/repositories/movies_repository.dart';
import 'features/movies/presentation/bloc/movies_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final apiService = ApiService();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      path: 'assets/lang',
      fallbackLocale: const Locale('tr', 'TR'),
      child: Phoenix(
        child: RepositoryProvider<MoviesRepository>(
          create: (_) => MoviesRepositoryImpl(apiService),
          child: ScreenUtilInit(
            designSize: const Size(411, 731),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => const MyApp(),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<MoviesBloc>(
          create: (context) => MoviesBloc(),
        ),
      ],
      child: MaterialApp.router(
        title: 'ShartFlix',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
