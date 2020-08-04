import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventMenuEntity extends Equatable {
  final String itemId;
  final String itemName;
  final int itemType;
  final double itemValue;

  const EventMenuEntity(
      this.itemId, this.itemName, this.itemType, this.itemValue);

  Map<String, Object> toJson() {
    return {
      "itemId": itemId,
      "itemName": itemName,
      "itemType": itemType,
      "itemValue": itemValue,
    };
  }

  @override
  List<Object> get props => [itemId, itemName, itemType, itemValue];

  @override
  String toString() {
    return 'EventMenuEntity { itemId: $itemId, itemName: $itemName itemType: $itemType, itemValue: $itemValue }';
  }

  static EventMenuEntity fromJson(Map<String, Object> json) {
    return EventMenuEntity(
      json["itemId"] as String,
      json["itemName"] as String,
      json["itemType"] as int,
      json["itemValue"] as double,
    );
  }

  static EventMenuEntity fromSnapshot(DocumentSnapshot snap) {
    return EventMenuEntity(
      snap.documentID,
      snap.data['itemName'],
      snap.data['itemType'],
      snap.data['itemValue'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "itemName": itemName,
      "itemType": itemType,
      "itemValue": itemValue,
    };
  }
}
