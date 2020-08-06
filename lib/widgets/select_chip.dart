import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutterApp/theme.dart';

class SelectChip extends StatefulWidget {
  final String eventId;
  final String itemId;
  final String userId;

  const SelectChip({Key key, this.eventId, this.itemId, this.userId})
      : super(key: key);

  @override
  _SelectChipState createState() => _SelectChipState();
}

class _SelectChipState extends State<SelectChip> {
  int tag = 1;
  String title = 'loading';
//  List<String> tags = [];

  List<String> options = [
    'food',
    'alcohol',
    'dessert',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: Firestore.instance
          .collection('Events')
          .document(widget.eventId)
          .collection('Menu')
          .document(widget.itemId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {

            tag = snapshot.data['itemType'];
            title = snapshot.data['itemName'] +
                ' ' +
                snapshot.data['itemValue'].toString();
          return Content(
            title: title,
            child: ChipsChoice<int>.single(
              value: tag,
              options: ChipsChoiceOption.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
              onChanged: (val) => setState(() async {
                tag = val;
                await Firestore.instance
                    .collection('Events')
                    .document(widget.eventId)
                    .collection('Menu')
                    .document(widget.itemId)
                    .updateData({'itemType': tag});
              }),
            ),
          );
        }
        return Content(
          title: title,
          child: ChipsChoice<int>.single(
            value: tag,
            options: ChipsChoiceOption.listFrom<int, String>(
              source: options,
              value: (i, v) => i,
              label: (i, v) => v,
            ), onChanged: (int value) {  },
          ),
        );
      },
    );
  }
}

class Content extends StatelessWidget {
  final String title;
  final Widget child;

  Content({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            color: MyColors.primaryColor,
            child: Text(
              title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
