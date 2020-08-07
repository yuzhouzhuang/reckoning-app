import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterApp/pages/home_page.dart';
import 'package:flutterApp/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterApp/pages/pages.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'blocs/blocs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light) // Or Brightness.dark
      );
  runApp(BlocProvider(
    create: (context) => AuthBloc()..add(AuthEventAppStart()),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(platform: TargetPlatform.iOS),
      initialRoute: SplashPage.routeName,
//      routes: {
//        SplashPage.routeName: (context) => SplashPage(),
//        LoginPage.routeName: (context) => LoginPage(),
//        HomePage.routeName: (context) => HomePage(),
//        OtpPage.routeName: (context) => OtpPage(),
//        AddEventModal.routeName: (context) => AddEventModal(),
//      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case LoginPage.routeName:
            return MaterialWithModalsPageRoute(
                builder: (_) => LoginPage(), settings: settings);
          case HomePage.routeName:
            return MaterialWithModalsPageRoute(
                builder: (_) => HomePage(), settings: settings);
          case OtpPage.routeName:
            return MaterialWithModalsPageRoute(
                builder: (_) => OtpPage(), settings: settings);
          case AddEventModal.routeName:
            return MaterialWithModalsPageRoute(
                builder: (_) => AddEventModal(), settings: settings);
          case EventPage.routeName:
            return MaterialWithModalsPageRoute(
                builder: (_) => EventPage(), settings: settings);
          case InvitePage.routeName:
            return MaterialWithModalsPageRoute(
                builder: (_) => InvitePage(), settings: settings);
        }
        return MaterialWithModalsPageRoute(
            builder: (_) => SplashPage(), settings: settings);
      },
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateUninitialized) {
          Navigator.of(context).pushNamed(SplashPage.routeName);
        }

        if (state is AuthStateAuthenticated) {
          Navigator.of(context).pushNamed(HomePage.routeName);
        }

        if (state is AuthStateUnauthenticated) {
          Navigator.of(context).pushNamed(LoginPage.routeName);
        }
      },
      child: Container(),
    );
  }
}
