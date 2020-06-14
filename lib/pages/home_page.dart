import 'package:flutter/material.dart';
import 'package:flutterApp/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomePage extends StatelessWidget {

  final String name;

  HomePage({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AuthEventLogout());
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Text('Welcome $name'),
          )
        ],
      ),
    );
  }
}
