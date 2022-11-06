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
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AppNavigator(),
          ),
        ));
  }
}
