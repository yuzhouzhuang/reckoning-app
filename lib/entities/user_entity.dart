import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterApp/entities/user_event_entity.dart';

class UserEntity extends Equatable {
  final String uid;
  final String userName;
  final String phone;

  const UserEntity(this.uid, this.userName, this.phone);

  Map<String, Object> toJson() {
    return {
      "uid": uid,
      "userName": userName,
      "phone": phone,
    };
  }

  @override
  List<Object> get props => [uid, userName, phone];

  @override
  String toString() {
    return 'UserEntity { uid: $uid, userName: $userName, phone: $phone }';
  }

  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
      json["uid"] as String,
      json["userName"] as String,
      json["phone"] as String,
    );
  }

  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    //List<UserEventEntity> list = (await snap.reference.collection('Events').snapshots().map((event) => event.documents.map((e) => UserEventEntity.fromSnapshot(e))).toList()).cast<UserEventEntity>();
    return UserEntity(
      snap.documentID,
      snap.data['userName'],
      snap.data['phone']
    );
  }


  Map<String, Object> toDocument() {
    return {
      "userName": userName,
      "phone": phone,
    };
  }
}
