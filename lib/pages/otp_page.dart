import 'package:flutter/material.dart';
import 'package:flutterApp/blocs/blocs.dart';
import 'package:flutterApp/pages/pages.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';


class OtpPage extends StatefulWidget {
  static const routeName = '/OtpPage';

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: MyColors.primaryColorLight),
      borderRadius: BorderRadius.circular(15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateAuthenticated) {
          Navigator.of(context)
              .pushNamed(HomePage.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: MyColors.primaryColorLight.withAlpha(20),
                ),
                child: Icon(Icons.arrow_back_ios, color: MyColors.primaryColor, size: 16,),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text('Enter 6 digits verification code sent to your number', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500))
                            ),
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.all(20),
                              child: PinPut(
                                fieldsCount: 6,
                                focusNode: _pinPutFocusNode,
                                controller: _pinPutController,
                                submittedFieldDecoration: _pinPutDecoration.copyWith(
                                    borderRadius: BorderRadius.circular(20)),
                                selectedFieldDecoration: _pinPutDecoration,
                                followingFieldDecoration: _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: MyColors.primaryColorLight.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              constraints: const BoxConstraints(
                                  maxWidth: 500
                              ),
                              child: RaisedButton(
                                onPressed: () {
                                  BlocProvider.of<AuthBloc>(context).add(AuthEventValidatePhoneNumber(smsCode: _pinPutController.text));
                                },
                                color: MyColors.primaryColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(14))
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Confirm', style: TextStyle(color: Colors.white),),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                          color: MyColors.primaryColorLight,
                                        ),
                                        child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Container(
          height: 80.0,
          child: Center(
            child: Text(
              'Pin Submitted. Value: $pin',
              style: TextStyle(fontSize: 25.0),
            ),
          )),
      backgroundColor: Colors.deepPurpleAccent,
    );
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
