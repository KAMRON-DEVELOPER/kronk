import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kronk/screens/screens.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/connectivity/connectivity_bloc.dart';
import '../bloc/notes/notes_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../provider/profile_mode_provider.dart';


routes(RouteSettings settings, BuildContext context) {
  switch (settings.name) {
    case "/intro":
      return PageTransition(
        child: const IntroScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case "/home":
      return PageTransition(
        child: ChangeNotifierProvider(
          create: (context) => ProfileModeProvider(),
          child: BlocProvider(
            create: (context) => ProfileBloc(
              connectivityBloc: context.read<ConnectivityBloc>(),
            ),
            child: const HomeScreen(),
          ),
        ),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/home/notes':
      return PageTransition(
        child: BlocProvider(
          create: (context) => NotesBloc(
            connectivityBloc: context.read<ConnectivityBloc>(),
          ),
          child: const NotesScreen(),
        ),
        type: PageTransitionType.rightToLeft,
        duration: const Duration(seconds: 1),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/home/register':
      return PageTransition(
        child: BlocProvider(
          create: (context) => AuthenticationBloc(),
          child: const RegisterScreen(),
        ),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/home/verify':
      return PageTransition(
        child: BlocProvider(
          create: (context) => AuthenticationBloc(),
          child: const VerifyScreen(),
        ),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/home/login':
      return PageTransition(
        child: BlocProvider(
          create: (context) => AuthenticationBloc(),
          child: const LoginScreen(),
        ),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/community':
      return PageTransition(
        child: const CommunityScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/education':
      return PageTransition(
        child: BlocProvider(
          create: (context) => ProfileBloc(
            connectivityBloc: context.read<ConnectivityBloc>(),
          ),
          child: const EducationScreen(),
        ),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/entertainment':
      return PageTransition(
        child: BlocProvider(
          create: (context) => ProfileBloc(
            connectivityBloc: context.read<ConnectivityBloc>(),
          ),
          child: const EntertainmentScreen(),
        ),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/jobs':
      return PageTransition(
        child: BlocProvider(
          create: (_) => ProfileBloc(
            connectivityBloc: context.read<ConnectivityBloc>(),
          ),
          child: const JobsScreen(),
        ),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/ai':
      return PageTransition(
        child: const AiScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        settings: settings,
      );
    default:
      return null;
  }
}
