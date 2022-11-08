import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oart/app_navigator.dart';
import 'package:oart/auth/auth_cubit.dart';
import 'package:oart/auth/auth_repository.dart';
import 'package:oart/auth/login/bloc/login_bloc.dart';
import 'package:oart/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:oart/bar/bottom_nav_bar_cubit.dart';
import 'package:oart/feed/bloc/feed_bloc.dart';
import 'package:oart/feed/feed_navigator_cubit.dart';
import 'package:oart/map/bloc/map_bloc.dart';
import 'package:oart/map/map_navigator_cubit.dart';
import 'package:oart/map/map_repository.dart';
import 'package:oart/profile/profile_navigator_cubit.dart';
import 'package:oart/session_cubic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AuthRepository()),
          RepositoryProvider(create: (context) => MapRepository())
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => SessionCubit(
                    RepositoryProvider.of<AuthRepository>(context))),
            BlocProvider(
                create: (context) => AuthCubit(context.read<SessionCubit>())),
            BlocProvider(
              create: (context) => LoginBloc(
                RepositoryProvider.of<AuthRepository>(context),
                context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => SignUpBloc(
                RepositoryProvider.of<AuthRepository>(context),
                context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(create: (context) => BottomNavBarCubit()),
            BlocProvider(
                create: (context) =>
                    MapBloc(RepositoryProvider.of<MapRepository>(context))),
            BlocProvider(create: (context) => MapNavigatorCubit()),
            BlocProvider(create: (context) => FeedNavigatorCubit()),
            BlocProvider(create: (context) => FeedBloc()),
            BlocProvider(create: (context) => ProfileNavigatorCubit()),
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const AppNavigator(),
              theme: ThemeData(
                colorScheme: const ColorScheme(
                  primary: Color.fromARGB(255, 11, 2, 45),
                  secondary: Color.fromARGB(255, 77, 236, 200),
                  tertiary: Colors.white,
                  background: Color.fromARGB(255, 11, 2, 45),
                  brightness: Brightness.dark,
                  error: Colors.white,
                  onBackground: Colors.white,
                  onError: Colors.white,
                  onPrimary: Colors.white,
                  onSecondary: Colors.white,
                  onSurface: Colors.white,
                  surface: Colors.white,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                          const TextStyle(color: Colors.white)),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 77, 236, 200))),
                ),
                appBarTheme: const AppBarTheme(
                    backgroundColor: Color.fromARGB(255, 11, 2, 45)),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Color.fromARGB(255, 11, 2, 45),
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Color.fromARGB(255, 77, 236, 200),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                ),
              )),
        ));
  }
}
