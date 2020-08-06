import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterApp/Animation/FadeAnimation.dart';
import 'package:flutterApp/arguments/event_page_argument.dart';
import 'package:flutterApp/blocs/blocs.dart';
import 'package:flutterApp/logics/logics.dart';
import 'package:flutterApp/pages/event_page.dart';
import 'package:flutterApp/pages/modals/modals.dart';
import 'package:flutterApp/respositories/respositories.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutterApp/utils/eventUtil.dart';
import 'package:flutterApp/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'pages.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Invitation'),
    Tab(text: 'Payment'),
    Tab(text: 'All'),
  ];

  ScrollController scrollController;
  TabController tabController;
  final picker = ImagePicker();
  UserEventLogic userEventLogic;
  FirebaseUserInfoRepository userInfoRepository;
  String _eventName;

  @override
  void initState() {
    super.initState();
    _eventName = 'New Event';
    userInfoRepository = FirebaseUserInfoRepository();
    userEventLogic = UserEventLogic();
    scrollController = ScrollController(initialScrollOffset: 0);
    tabController = TabController(
      length: myTabs.length,
      vsync: this,
    );
  }

  Widget makeItem({image, eventName, acceptType, date}) {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 180,
          margin: EdgeInsets.only(right: 20),
          child: Column(
            children: <Widget>[
              Text(
                (date as DateTime).day.toString(),
                style: TextStyle(
                    color: MyColors.primaryColorLight,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                EventUtil.getMonth((date as DateTime).month),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: EventUtil.getColor(acceptType),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(.2),
                    Colors.black.withOpacity(.1),
                  ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    eventName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        (date as DateTime).toString().substring(0, 16),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        EventUtil.getIcon(acceptType),
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        EventUtil.getStatus(acceptType),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light) // Or Brightness.dark
        );
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        endDrawer: Container(
          width: MediaQuery.of(context).size.width * 0.618,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.618,
                  color: MyColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DrawerHeader(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.settings,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Settings",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    ListTile(
                      title: Text(
                        'Update Username:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance
                          .collection('Users')
                          .document((BlocProvider.of<AuthBloc>(context).state
                                  as AuthStateAuthenticated)
                              .user
                              .userId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ListTile(
                            title: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Colors.grey.withOpacity(0.5)),
                              child: TextFormField(
                                initialValue: "Something went wrong",
                              ),
                            ),
                          );
                        }

                        return ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.white),
                            child: TextFormField(
                              onChanged: (text) {
                                Firestore.instance
                                    .collection('Users')
                                    .document(
                                        (BlocProvider.of<AuthBloc>(context)
                                                    .state
                                                as AuthStateAuthenticated)
                                            .user
                                            .userId)
                                    .updateData({'userName': text})
                                    .then((value) => print("User Updated"))
                                    .catchError((error) =>
                                        print("Failed to update user: $error"));
                              },
                              initialValue: snapshot.data['userName'],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: RaisedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(AuthEventLogout());
                            //BlocProvider.of<AuthBloc>(context).add(AuthEventValidatePhoneNumber(smsCode: _pinPutController.text));
                          },
                          color: MyColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          )),
                          child: Center(
                              child: Text(
                            'Log out',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 5, top: 2),
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  onChanged: (text) => _eventName = text,
                                  decoration: InputDecoration(
                                      hintText: "New Event",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
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
                              final pickedFile = await picker.getImage(
                                  source: ImageSource.gallery);
                              asyncOCR(image: File(pickedFile.path), userId: (BlocProvider.of<AuthBloc>(context).state as AuthStateAuthenticated).user.userId);
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
                                    Icons.camera_alt,
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
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Users')
                        .document((BlocProvider.of<AuthBloc>(context).state
                                as AuthStateAuthenticated)
                            .user
                            .userId)
                        .collection('Events').orderBy('eventDate', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Text('Loading...');
                        default:
                          return new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return Column(children: <Widget>[
                                ListTile(
                                  onTap: () {
                                    //TODO
                                    Navigator.of(context).pushNamed(EventPage.routeName, arguments: EventPageArgument(eventId: document.documentID, userId: (BlocProvider.of<AuthBloc>(context).state as AuthStateAuthenticated).user.userId));
                                  },
                                  title: FadeAnimation(
                                      1.2,
                                      makeItem(
                                          acceptType: document['acceptType'],
                                          eventName: document['eventName'],
                                          date:
                                              (document['eventDate'] as Timestamp)
                                                  .toDate())),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ]);
                            }).toList(),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          CustomAppBar(scrollController: scrollController, titleText: 'Home'),
        ]),
      );
    });
  }

  void asyncOCR({image, userId}) async {
//    print('');
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    List<String> itemNameList = <String>[];
    List<double> itemValueList = <double>[];

    RegExp _numeric = RegExp(r'^£?-?[0-9]+.?[0-9]+$');

    for (TextBlock block in visionText.blocks) {
//      print('***');
      for (TextLine line in block.lines) {
        String text = line.text;
        if (_numeric.hasMatch(text)) {
          if (text.contains('£')) {
            text = text.substring(1);
          }
          itemValueList.add(double.parse(text));
        } else {
          itemNameList.add(text);
        }
      }
    }
    textRecognizer.close();

//    itemNameList.forEach((element) {
//      print(element);
//    });
//    itemValueList.forEach((element) {
//      print(element);
//    });

    Timestamp timestamp = Timestamp.fromDate(DateTime.now());
//    String userName = await Firestore.instance.collection('Users').document(userId).get().then((value) => value.data['userName']);
    String eventId = await Firestore.instance.collection('Events').add({
      'eventDate': timestamp,
      'eventName': _eventName,
      'ownerId': userId,
      'totalValue': itemValueList.elementAt(itemValueList.length - 1),
    }).then((value) => value.documentID);

    await Firestore.instance.collection('Users').document(userId).collection('Events').document(eventId).setData({
      'eventDate': timestamp,
      'eventName': _eventName,
      'acceptType': -1,
    });

    for (int index = 0; index < itemValueList.length - 1; index++) {
      String id = index.toString();
      while (id.length < 8) {
        id = '0' + id;
      }
      await Firestore.instance.collection('Events').document(eventId).collection('Menu').document(id).setData({
        'itemName': itemNameList.elementAt(index),
        'itemType': 0,
        'itemValue': itemValueList.elementAt(index),
      });
    }
  }
}
