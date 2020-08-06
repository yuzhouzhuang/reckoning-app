import 'dart:io';

import 'package:meta/meta.dart';

class EventPageArgument {
  final String eventId;
  final String userId;

  EventPageArgument({@required this.eventId, @required this.userId});
}