import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterApp/entities/user_event_entity.dart';

class EventEntity extends Equatable {
  final String eventId;
  final String eventName;
  final String ownerId;
  final double totalValue;
  final Timestamp eventDate;

  const EventEntity(this.eventId, this.eventName, this.ownerId, this.totalValue, this.eventDate);

  Map<String, Object> toJson() {
    return {
      "eventId": eventId,
      "eventName": eventName,
      "ownerId": ownerId,
      "totalValue": totalValue,
      "eventDate": eventDate,
    };
  }

  @override
  List<Object> get props => [eventId, eventName, ownerId, totalValue, eventDate];

  @override
  String toString() {
    return 'UserEntity { eventId: $eventId, eventName: $eventName, ownerId: $ownerId, totalValue: $totalValue, eventDate: $eventDate }';
  }

  static EventEntity fromJson(Map<String, Object> json) {
    return EventEntity(
      json["eventId"] as String,
      json["eventName"] as String,
      json["ownerId"] as String,
      json["totalValue"] as double,
      json["eventDate"] as Timestamp,
    );
  }

  static EventEntity fromSnapshot(DocumentSnapshot snap) {
    //List<UserEventEntity> list = (await snap.reference.collection('Events').snapshots().map((event) => event.documents.map((e) => UserEventEntity.fromSnapshot(e))).toList()).cast<UserEventEntity>();
    return EventEntity(
      snap.documentID,
      snap.data['eventName'],
      snap.data['ownerId'],
      snap.data['totalValue'],
      snap.data['eventDate'],
    );
  }


  Map<String, Object> toDocument() {
    return {
      "eventName": eventName,
      "ownerId": ownerId,
      "totalValue": totalValue,
      "eventDate": eventDate
    };
  }
}
