import 'package:flutter/material.dart';
import 'package:flutterApp/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterApp/pages/pages.dart';

import 'blocs/blocs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(BlocProvider(
    create: (context) => AuthBloc()..add(AuthEventAppStart()),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (context) => SplashPage(),
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        OtpPage.routeName: (context) => OtpPage(),
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
