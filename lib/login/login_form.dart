import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterApp/user_repository.dart';
import 'package:flutterApp/authentication/bloc/bloc.dart';
import 'package:flutterApp/login/login.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneNumberController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;


  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginInvalidPhoneNumber) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Invalid phone number'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state is LoginInvalidSMSCode) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Wrong verification code'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }

        if (state is LoginValidPhoneNumber) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Valid phone number'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }

        if (state is LoginValidSMSCode) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 240,
                                    constraints: const BoxConstraints(
                                        maxWidth: 500
                                    ),
                                    margin: const EdgeInsets.only(top: 100),
                                    decoration: const BoxDecoration(color: Color(0xFFE1E0F5), borderRadius: BorderRadius.all(Radius.circular(30))),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                      constraints: const BoxConstraints(maxHeight: 340),
                                      margin: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Image.asset('assets/img/login.png')),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('TheGorgeousOtp',
                                  style: TextStyle(color: MyColors.primaryColor, fontSize: 30, fontWeight: FontWeight.w800)))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 500
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(text: 'We will send you an ', style: TextStyle(color: MyColors.primaryColor)),
                                  TextSpan(
                                      text: 'One Time Password ', style: TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.bold)),
                                ]),
                              )),
                          Container(
                            height: 40,
                            constraints: const BoxConstraints(
                                maxWidth: 500
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: CupertinoTextField(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(4))
                              ),
                              controller: _phoneNumberController,
                              clearButtonMode: OverlayVisibilityMode.editing,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              placeholder: '+33...',
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            constraints: const BoxConstraints(
                                maxWidth: 500
                            ),
                            child: RaisedButton(
                              onPressed: () {
                                if (_phoneNumberController.text.isNotEmpty) {
                                  _loginBloc.add(VerifyPhonePressed(phoneNumber: _phoneNumberController.text.toString()));
                                } else {
                                  Scaffold.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Please enter a phone number',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                }
                              },
                              color: MyColors.primaryColor,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Next',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        color: MyColors.primaryColorLight,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
