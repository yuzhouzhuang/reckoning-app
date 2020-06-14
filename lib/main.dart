import 'package:flutter/material.dart';
import 'package:flutterApp/pages/home_page.dart';
import 'package:flutterApp/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterApp/user_repository.dart';
import 'package:flutterApp/pages/pages.dart';

import 'blocs/blocs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    create: (context) =>
        AuthBloc(userRepository: userRepository)..add(AuthEventAppStart()),
    child: App(
      userRepository: userRepository,
    ),
  ));
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthStateUninitialized) {
          return SplashPage();
        }

        if (state is AuthStateAuthenticated) {
          return HomePage(
              name: state.user.phoneNumber);
        }

        if (state is AuthStateUnauthenticated) {
          return LoginPage(userRepository: _userRepository);
        }
        
        if (state is AuthStateCodeSent) {
          return HomePage(
              name: state.phoneNumber);
        }
        return Container();
      }),
    );
  }
}
