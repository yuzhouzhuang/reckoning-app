import 'package:flutter/material.dart';
import 'package:flutterApp/user_repository.dart';
import 'package:flutterApp/register/register.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return RegisterScreen(userRepository: _userRepository);
          }));
        },
        child: Text('Create an Account'));
  }
}
