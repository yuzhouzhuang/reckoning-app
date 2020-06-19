import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterApp/blocs/blocs.dart';
import 'package:flutterApp/pages/modals/modals.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutterApp/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 100);
    tabController = TabController(
      length: myTabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TabBar(
                        tabs: myTabs,
                        controller: tabController,
                        labelColor: Colors.grey[700],
                        indicatorColor: MyColors.primaryColor,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 150,
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Container(
                                  color: Colors.red,
                                  height: 20,
                                ),
                              ],
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Container(
                                  color: Colors.red,
                                  height: 20,
                                ),
                                Container(
                                  color: Colors.red,
                                  height: 20,
                                ),
                              ],
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Container(
                                  color: Colors.red,
                                  height: 20,
                                ),
                                Container(
                                  color: Colors.red,
                                  height: 20,
                                ),
                                Container(
                                  color: Colors.red,
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                          controller: tabController,
                        ),
                      ),
//                    makePost(Sample.postOne),
//                    makePost(Sample.postTwo),
                    ],
                  ),
                )
              ],
            ),
          ),
          CustomAppBar(scrollController: scrollController, titleText: 'Events'),
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
            flex: 4,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
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
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context, scrollController) =>
                        AddEventModal(scrollController: scrollController),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                height: 40,
                minWidth: 50,
                elevation: 0,
                color: MyColors.primaryColor,
                child: Text(
                  'Add event',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
