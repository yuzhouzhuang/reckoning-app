// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/entities.dart';

class FirebaseEventInfoRepository {
  final CollectionReference eventCollection =
      Firestore.instance.collection('Events');

  Future<void> addNewEventEntity(EventEntity eventEntity) {
    return eventCollection.add(eventEntity.toDocument());
  }

  Future<void> deleteEventEntity(EventEntity eventEntity) async {
    return eventCollection.document(eventEntity.eventId).delete();
  }

  Future<UserEntity> getEventEntity(String uid) {
    return eventCollection.document(uid).get().then((snapshot) {
      return UserEntity.fromSnapshot(snapshot);
    });
  }

  Future<void> updateEventEntity(EventEntity eventEntity) {
    return eventCollection
        .document(eventEntity.eventId)
        .updateData(eventEntity.toDocument());
  }
}
