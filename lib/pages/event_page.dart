import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutterApp/arguments/event_page_argument.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutterApp/widgets/widgets.dart';

class EventPage extends StatefulWidget {
  static const routeName = '/eventPage';

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    final EventPageArgument args = ModalRoute.of(context).settings.arguments;

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
            child: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColor,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Menu',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
//        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('Events')
                  .document(args.eventId)
                  .collection('Menu')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Dismissible(
                          onDismissed: (e) async {
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "${document.data['itemName']} deleted")));
                            await Firestore.instance
                                .collection('Events')
                                .document(args.eventId)
                                .collection('Menu')
                                .document(document.documentID)
                                .delete();
                          },
                          key: Key(document.documentID),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SelectChip(
                                eventId: args.eventId,
                                itemId: document.documentID,
                                userId: args.userId,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 200.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection('Events')
                    .document(args.eventId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  return ListTile(
                    title: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Colors.white),
                      child: TextFormField(
                        onChanged: (text) {
                          Firestore.instance
                              .collection('Events')
                              .document(args.eventId)
                              .updateData({
                            'totalValue': double.parse(text.substring(7))
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        initialValue:
                            'Total:£' + snapshot.data['totalValue'].toString(),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 500),
              child: RaisedButton(
                onPressed: () {
                  Firestore.instance
                      .collection('User')
                      .document(args.userId)
                      .collection('Events')
                      .document(args.eventId)
                      .updateData({
                    'acceptType': -2,
                  });
//                    asyncOCR();
//                BlocProvider.of<AuthBloc>(context).add(AuthEventValidatePhoneNumber(smsCode: _pinPutController.text));
                },
                color: MyColors.primaryColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Send Invitations',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
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
            ),
          ],
        ),
      ),
    );
  }
}
