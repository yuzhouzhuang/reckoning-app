import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterApp/arguments/event_page_argument.dart';
import 'package:flutterApp/theme.dart';

class EventPage extends StatefulWidget {
  static const routeName = '/eventPage';

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {


  @override
  Widget build(BuildContext context) {
    final EventPageArgument args = ModalRoute.of(context).settings.arguments;
    File image = args.image;
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: image == null
                  ? Text('No image selected.')
                  : Image.file(image, height: 200,),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            constraints: const BoxConstraints(
                maxWidth: 500
            ),
            child: RaisedButton(
              onPressed: () {
//                BlocProvider.of<AuthBloc>(context).add(AuthEventValidatePhoneNumber(smsCode: _pinPutController.text));
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
                    Text('Create Event', style: TextStyle(color: Colors.white),),
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
    );
  }
}
