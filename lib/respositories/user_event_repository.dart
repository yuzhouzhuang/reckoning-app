// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/entities.dart';

class FirebaseUserEventRepository {
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  Future<void> addNewUserEventEntity(UserEventEntity userEventEntity, String uid) {
    return userCollection
        .document(uid)
        .collection('Events')
        .add(userEventEntity.toDocument());
  }

  Future<void> deleteUserEventEntity(
      UserEventEntity userEventEntity, String uid) async {
    return userCollection
        .document(uid)
        .collection('Events')
        .document(userEventEntity.eventId)
        .delete();
  }

  Future<List<UserEventEntity>> getUserEventEntity(String uid) {
    return userCollection
        .document(uid)
        .collection('Events')
        .getDocuments()
        .then((snapshot) => snapshot.documents
            .map((result) => UserEventEntity.fromSnapshot(result))
            .toList());
  }

  Future<void> updateUserEventEntity(UserEventEntity userEventEntity, String uid) {
    return userCollection
        .document(uid)
        .collection('Events')
        .document(userEventEntity.eventId)
        .updateData(userEventEntity.toDocument());
  }
}
