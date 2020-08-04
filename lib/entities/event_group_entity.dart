import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventGroupEntity extends Equatable {
  final String uid;
  final int userType;
  final double paidAmount;

  const EventGroupEntity(this.uid, this.userType, this.paidAmount);

  Map<String, Object> toJson() {
    return {
      "uid": uid,
      "userType": userType,
      "paidAount": paidAmount,
    };
  }

  @override
  List<Object> get props =>
      [uid, userType, paidAmount];

  @override
  String toString() {
    return 'UserEventEntity { uid: $uid, userType: $userType, paidAount: $paidAmount }';
  }

  static EventGroupEntity fromJson(Map<String, Object> json) {
    return EventGroupEntity(
      json["uid"] as String,
      json["userType"] as int,
      json["paidAmount"] as double,
    );
  }

  static EventGroupEntity fromSnapshot(DocumentSnapshot snap) {
    return EventGroupEntity(
      snap.documentID,
      snap.data['userType'],
      snap.data['paidAmount'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "userType": userType,
      "paidAount": paidAmount,
    };
  }
}
