import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterApp/Animation/FadeAnimation.dart';
import 'package:flutterApp/arguments/event_page_argument.dart';
import 'package:flutterApp/blocs/blocs.dart';
import 'package:flutterApp/pages/event_page.dart';
import 'package:flutterApp/pages/modals/modals.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutterApp/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);
    tabController = TabController(
      length: myTabs.length,
      vsync: this,
    );
  }


  Widget makeItem({image, date}) {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 200,
          margin: EdgeInsets.only(right: 20),
          child: Column(
            children: <Widget>[
              Text(date.toString(), style: TextStyle(color: MyColors.primaryColorLight, fontSize: 25, fontWeight: FontWeight.bold),),
              Text("SEP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover
                )
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.1),
                      ]
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Bumbershoot 2019", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text("19:00 PM", style: TextStyle(color: Colors.white),)
                    ],
                  )
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light) // Or Brightness.dark
    );
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                searchBox(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(1.2, makeItem(image: 'assets/images/one.jpg', date: 17)),
                      SizedBox(height: 20,),
                      FadeAnimation(1.3, makeItem(image: 'assets/images/two.jpg', date: 18)),
                      SizedBox(height: 20,),
                      FadeAnimation(1.4, makeItem(image: 'assets/images/three.jpg', date: 19)),
                      SizedBox(height: 20,),
                      FadeAnimation(1.5, makeItem(image: 'assets/images/four.jpg', date: 20)),
                      SizedBox(height: 20,),
                    ],
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

  Widget searchBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)), color: Color.fromRGBO(238, 238, 238, 1)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5, top: 2),
                    child: Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Search",
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
                  final pickedFile = await picker.getImage(source: ImageSource.camera);
                  Navigator.of(context).pushNamed(EventPage.routeName, arguments: EventPageArgument(image: File(pickedFile.path)));
//                  showCupertinoModalBottomSheet(
//                    expand: false,
//                    context: context,
//                    backgroundColor: Colors.transparent,
//                    builder: (context, scrollController) =>
//                        AddEventModal(scrollController: scrollController),
//                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                height: 40,
                minWidth: 50,
                elevation: 0,
                color: MyColors.primaryColor,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.camera_alt, color: Colors.white,),
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
    );
  }
}
