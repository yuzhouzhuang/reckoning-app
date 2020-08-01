import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEventEntity extends Equatable {
  final String eventId;
  final int acceptType;
  final bool isOwner;
  final Timestamp eventDate;
  final double paymentAmount;

  const UserEventEntity(this.eventId, this.acceptType, this.isOwner,
      this.eventDate, this.paymentAmount);

  Map<String, Object> toJson() {
    return {
      "eventId": eventId,
      "acceptType": acceptType,
      "isOwner": isOwner,
      "eventDate": eventDate,
      "paymentAount": paymentAmount,
    };
  }

  @override
  List<Object> get props =>
      [eventId, acceptType, isOwner, eventDate, paymentAmount];

  @override
  String toString() {
    return 'UserEventEntity { eventId: $eventId, acceptType: $acceptType, isOwner: $isOwner,eventDate: $eventDate,paymentAount: $paymentAmount }';
  }

  static UserEventEntity fromJson(Map<String, Object> json) {
    return UserEventEntity(
      json["eventId"] as String,
      json["acceptType"] as int,
      json["isOwner"] as bool,
      json["eventDate"] as Timestamp,
      json["paymentAmount"] as double,
    );
  }

  static UserEventEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEventEntity(
      snap.documentID,
      snap.data['acceptType'],
      snap.data['isOwner'],
      snap.data['eventDate'],
      snap.data['paymentAmount'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "acceptType": acceptType,
      "isOwner": isOwner,
      "eventDate": eventDate,
      "paymentAount": paymentAmount,
    };
  }
}
