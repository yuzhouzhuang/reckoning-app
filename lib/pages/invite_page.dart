import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutterApp/arguments/event_page_argument.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutterApp/widgets/group_select_chip.dart';
import 'package:flutterApp/widgets/widgets.dart';

class InvitePage extends StatefulWidget {
  static const routeName = '/invitePage';

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  
  String _phoneNumber = '';
  
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
          'Group',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
//        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(14)),
                          color: Color.fromRGBO(238, 238, 238, 1)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.phone_iphone,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: TextField(
                                decoration: InputDecoration(border: InputBorder.none),
                                onChanged: (text) => _phoneNumber = text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: MaterialButton(
                        onPressed: () async {
                          print(_phoneNumber);
                          Map<String, Object> map = await Firestore.instance
                              .collection('Events').document(args.eventId).get().then((snapshot) => snapshot.data);
                          List<String> idList = await Firestore.instance
                              .collection('Users').where('phone', isEqualTo: _phoneNumber).getDocuments().then((snapshot) => snapshot.documents
                              .map((result) => result.documentID.toString())
                              .toList());
                          Map<String, Object> data = await Firestore.instance
                              .collection('Events').document(args.eventId)
                              .collection('Group').document( _phoneNumber).get().then((snapshot) => snapshot.data);
                          if (idList.length > 0 && data == null) {
                            await Firestore.instance
                                .collection('Users')
                                .document(idList.elementAt(0))
                                .collection('Events')
                                .document(args.eventId)
                                .setData({'acceptType': idList.elementAt(0) == args.userId ? -2 : 1, 'eventName': map['eventName'], 'eventDate': map['eventDate'],});

                            await Firestore.instance
                                .collection('Events')
                                .document(args.eventId)
                                .collection('Group')
                                .document(_phoneNumber)
                                .setData({'userType': 0, 'paidAmount': 0});
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(14))),
                        height: 40,
                        minWidth: 50,
                        elevation: 0,
                        color: MyColors.primaryColor,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.add ,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('Events')
                  .document(args.eventId)
                  .collection('Group')
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
                            List<String> idList = await Firestore.instance
                                .collection('Users').where('phone', isEqualTo: document.documentID).getDocuments().then((snapshot) => snapshot.documents
                                .map((result) => result.documentID.toString())
                                .toList());
                            String userName = await Firestore.instance
                                .collection('Users')
                                .document(idList.elementAt(0)).get().then((value) => value.data['userName']);
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "$userName removed")));
                            await Firestore.instance
                                .collection('Events')
                                .document(args.eventId)
                                .collection('Group')
                                .document(document.documentID)
                                .delete();
                            String userId = await Firestore.instance
                                .collection('Users')
                                .document(idList.elementAt(0)).get().then((value) => value.documentID);
                            if (userId != args.userId) {
                              await Firestore.instance
                                  .collection('Users')
                                  .document(idList.elementAt(0))
                                  .collection('Events')
                                  .document(args.eventId)
                                  .delete();
                            }
                          },
                          key: Key(document.documentID),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: GroupSelectChip(
                                eventId: args.eventId,
                                itemId: document.documentID,
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
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
