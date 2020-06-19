import 'package:flutter/material.dart';

class AddEventModal extends StatefulWidget {
  static const routeName = '/addEventPage';
  final ScrollController scrollController;

  const AddEventModal({Key key, this.scrollController}) : super(key: key);

  @override
  _AddEventModalState createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Edit'),
              leading: Icon(Icons.edit),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: Text('Copy'),
              leading: Icon(Icons.content_copy),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: Text('Cut'),
              leading: Icon(Icons.content_cut),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: Text('Move'),
              leading: Icon(Icons.folder_open),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: Text('Delete'),
              leading: Icon(Icons.delete),
              onTap: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }
}
