import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterApp/entities/user_event_entity.dart';

class UserEntity extends Equatable {
  final String uid;
  final String userName;
  final List<UserEventEntity> userEvents;

  const UserEntity(this.uid, this.userName, this.userEvents);

  Map<String, Object> toJson() {
    return {
      "uid": uid,
      "userName": userName,
      "userEvents": userEvents.map((element) => element.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [uid, userName, userEvents];

  @override
  String toString() {
    return 'UserEntity { uid: $uid, userName: $userName, userEvents: ${userEvents.map((element) => element.toJson()).toList()}';
  }

  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
      json["uid"] as String,
      json["userName"] as String,
      json["userEvents"] as List<UserEventEntity>,
    );
  }

  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    //List<UserEventEntity> list = (await snap.reference.collection('Events').snapshots().map((event) => event.documents.map((e) => UserEventEntity.fromSnapshot(e))).toList()).cast<UserEventEntity>();
    return UserEntity(
      snap.documentID,
      snap.data['userName'],
      null,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "userName": userName,
      "userEvents": userEvents.map((element) => element.toJson()).toList(),
    };
  }
}
