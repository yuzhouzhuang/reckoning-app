import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  bool takeOffKids = false;
  bool takeOffDrink = false;

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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
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
                                decoration:
                                    InputDecoration(border: InputBorder.none),
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
                              .collection('Events')
                              .document(args.eventId)
                              .get()
                              .then((snapshot) => snapshot.data);
                          List<String> idList = await Firestore.instance
                              .collection('Users')
                              .where('phone', isEqualTo: _phoneNumber)
                              .getDocuments()
                              .then((snapshot) => snapshot.documents
                                  .map((result) => result.documentID.toString())
                                  .toList());
                          Map<String, Object> data = await Firestore.instance
                              .collection('Events')
                              .document(args.eventId)
                              .collection('Group')
                              .document(_phoneNumber)
                              .get()
                              .then((snapshot) => snapshot.data);
                          if (idList.length > 0 && data == null) {
                            await Firestore.instance
                                .collection('Users')
                                .document(idList.elementAt(0))
                                .collection('Events')
                                .document(args.eventId)
                                .setData({
                              'acceptType':
                                  idList.elementAt(0) == args.userId ? -2 : 1,
                              'eventName': map['eventName'],
                              'eventDate': map['eventDate'],
                            });

                            await Firestore.instance
                                .collection('Events')
                                .document(args.eventId)
                                .collection('Group')
                                .document(_phoneNumber)
                                .setData({
                              'userType': 0,
                              'paidAmount': 0,
                              'acceptType': false,
                            });
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
                                Icons.add,
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
                                .collection('Users')
                                .where('phone', isEqualTo: document.documentID)
                                .getDocuments()
                                .then((snapshot) => snapshot.documents
                                    .map((result) =>
                                        result.documentID.toString())
                                    .toList());
                            String userName = await Firestore.instance
                                .collection('Users')
                                .document(idList.elementAt(0))
                                .get()
                                .then((value) => value.data['userName']);
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("$userName removed")));
                            await Firestore.instance
                                .collection('Events')
                                .document(args.eventId)
                                .collection('Group')
                                .document(document.documentID)
                                .delete();
                            String userId = await Firestore.instance
                                .collection('Users')
                                .document(idList.elementAt(0))
                                .get()
                                .then((value) => value.documentID);
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
                                color: (document.data['accept'] != null &&  document.data['accept'] == true)
                                    ? MyColors.primaryColor
                                    : Colors.red.withOpacity(0.5),
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
            CheckboxListTile(
              activeColor: MyColors.primaryColor,
              title: const Text('Take off the kids'),
              value: takeOffKids,
              onChanged: (bool value) {
                setState(() {
                  takeOffKids = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            CheckboxListTile(
              activeColor: MyColors.primaryColor,
              title: const Text('Take off the drink from non-drinkers'),
              value: takeOffDrink,
              onChanged: (bool value) {
                  setState(() {
                    takeOffDrink = value;
                  });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 500),
              child: RaisedButton(
                onPressed: () async {
                  //TODO
                  List<bool> acceptList = await Firestore.instance
                      .collection('Events')
                      .document(args.eventId)
                      .collection('Group')
                      .where('accept', isEqualTo: false)
                      .getDocuments()
                      .then((value) => value.documents
                          .map((e) => (e.data['accept'] as bool))
                          .toList());

                  if (acceptList.length > 0) {
                    showDialog(
                        context: context,
                        child: CupertinoAlertDialog(
                          title: Text('Invitations still wait for acceptence'),
                        ));
                  } else {
                    double totalAmount = await Firestore.instance
                        .collection('Events')
                        .document(args.eventId)
                        .get()
                        .then((value) => value.data['totalValue']);
                    double alcoholAmount = 0;
                    await Firestore.instance
                        .collection('Events')
                        .document(args.eventId)
                        .collection('Menu')
                        .getDocuments()
                        .then((value) => value.documents.forEach((element) {
                              if (element.data['itemType'] == 1) {
                                alcoholAmount += element.data['itemValue'];
                              }
                            }));

                    List<String> childList = await Firestore.instance
                        .collection('Events')
                        .document(args.eventId)
                        .collection('Group')
                        .where('userType', isEqualTo: 1)
                        .getDocuments()
                        .then((value) =>
                            value.documents.map((e) => e.documentID).toList());

                    List<String> nonDrinkerList = await Firestore.instance
                        .collection('Events')
                        .document(args.eventId)
                        .collection('Group')
                        .where('userType', isEqualTo: 2)
                        .getDocuments()
                        .then((value) =>
                            value.documents.map((e) => e.documentID).toList());

                    List<String> adultList = await Firestore.instance
                        .collection('Events')
                        .document(args.eventId)
                        .collection('Group')
                        .where('userType', isEqualTo: 0)
                        .getDocuments()
                        .then((value) =>
                            value.documents.map((e) => e.documentID).toList());

                    double childAmount = 0;
                    double nonDrinkerAmount = 0;
                    double adultAmount = 0;
                    if (takeOffDrink && takeOffKids) {
                      childAmount = 0;
                      nonDrinkerAmount = (totalAmount - alcoholAmount) /
                          (nonDrinkerList.length + adultList.length);
                      adultAmount = (totalAmount - alcoholAmount) /
                              (nonDrinkerList.length + adultList.length) +
                          alcoholAmount / adultList.length;
                    } else if (takeOffDrink) {
                      childAmount = (totalAmount - alcoholAmount) /
                          (childList.length +
                              nonDrinkerList.length +
                              adultList.length);
                      nonDrinkerAmount = (totalAmount - alcoholAmount) /
                          (childList.length +
                              nonDrinkerList.length +
                              adultList.length);
                      adultAmount = (totalAmount - alcoholAmount) /
                              (childList.length +
                                  nonDrinkerList.length +
                                  adultList.length) +
                          alcoholAmount / adultList.length;
                    } else if (takeOffKids) {
                      childAmount = 0;
                      nonDrinkerAmount = totalAmount /
                          (nonDrinkerList.length + adultList.length);
                      adultAmount = totalAmount /
                          (nonDrinkerList.length + adultList.length);
                    } else {
                      childAmount = totalAmount /
                          (childList.length +
                              nonDrinkerList.length +
                              adultList.length);
                      nonDrinkerAmount = totalAmount /
                          (childList.length +
                              nonDrinkerList.length +
                              adultList.length);
                      adultAmount = totalAmount /
                          (childList.length +
                              nonDrinkerList.length +
                              adultList.length);
                    }

                    childList.forEach((element) async {
                      await Firestore.instance
                          .collection('Events')
                          .document(args.eventId)
                          .collection('Group')
                          .document(element)
                          .updateData({'bill': childAmount});
                    });

                    nonDrinkerList.forEach((element) async {
                      await Firestore.instance
                          .collection('Events')
                          .document(args.eventId)
                          .collection('Group')
                          .document(element)
                          .updateData({'bill': nonDrinkerAmount});
                    });

                    adultList.forEach((element) async {
                      await Firestore.instance
                          .collection('Events')
                          .document(args.eventId)
                          .collection('Group')
                          .document(element)
                          .updateData({'bill': adultAmount});
                    });
                  }
                  await Firestore.instance
                      .collection('Users')
                      .document(args.userId)
                      .collection('Events')
                      .document(args.eventId)
                      .updateData({'acceptType': -4});
                  Navigator.of(context).pop();
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
                        'Divide the bill equally',
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
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
