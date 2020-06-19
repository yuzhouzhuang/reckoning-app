library fluent_appbar;

import 'package:flutter/material.dart';

import '../theme.dart';

class CustomAppBar extends StatefulWidget {
  CustomAppBar({
    Key key,
    @required this.titleText,
    @required this.scrollController,
    this.scrollOffset = 34,
    this.appBarColor = Colors.white,
    this.boxShadowColor = Colors.black,
    this.titleColor = Colors.black,
    this.titleFontWeight = FontWeight.bold,
  }) : super(key: key);

  final ScrollController scrollController;
  final int scrollOffset;
  final Color appBarColor;
  final Color boxShadowColor;
  final Color titleColor;
  final String titleText;
  final FontWeight titleFontWeight;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  double topBarOpacity = 0.0;
  Animation<double> topBarAnimation;
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animationController.forward();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    widget.scrollController.addListener(() {
      if (widget.scrollController.offset >= widget.scrollOffset) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (widget.scrollController.offset <= widget.scrollOffset &&
          widget.scrollController.offset >= 0) {
        if (topBarOpacity !=
            widget.scrollController.offset / widget.scrollOffset) {
          setState(() {
            topBarOpacity =
                widget.scrollController.offset / widget.scrollOffset;
          });
        }
      } else if (widget.scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getAppBarUI(context);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget getAppBarUI(context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.appBarColor.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: widget.boxShadowColor
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.titleText,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: widget.titleFontWeight,
                                      fontSize: 25 + 6 - 6 * topBarOpacity,
                                      color: widget.titleColor),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Container(
                                width: 25 + 6 - 6 * topBarOpacity,
                                height: 25 + 6 - 6 * topBarOpacity,
//                                  padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.person_outline, color: MyColors.primaryColorLight.withOpacity(1), size:  26 - 6 + 6 * topBarOpacity,),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
