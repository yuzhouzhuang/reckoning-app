import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutterApp/theme.dart';


class SelectChip extends StatefulWidget {
  @override
  _SelectChipState createState() => _SelectChipState();
}

class _SelectChipState extends State<SelectChip> {
  int tag = 1;
  List<String> tags = [];

  List<String> options = [
    'food',
    'alcohol',
    'dessert',
  ];

  @override
  Widget build(BuildContext context) {
    return Content(
      title: 'Scrollable List Single Choice',
      child: ChipsChoice<int>.single(
        value: tag,
        options: ChipsChoiceOption.listFrom<int, String>(
          source: options,
          value: (i, v) => i,
          label: (i, v) => v,
        ),
        onChanged: (val) => setState(() => tag = val),
      ),
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
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
