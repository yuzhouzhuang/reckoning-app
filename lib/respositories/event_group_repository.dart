// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/entities.dart';

class FirebaseEventGroupRepository {
  final CollectionReference eventCollection =
      Firestore.instance.collection('Events');

  Future<void> addNewEventGroupEntity(EventGroupEntity eventGroupEntity, String eventId) {
    return eventCollection
        .document(eventId)
        .collection('Group')
        .add(eventGroupEntity.toDocument());
  }

  Future<void> deleteEventGroupEntity(
      EventGroupEntity eventGroupEntity, String eventId) async {
    return eventCollection
        .document(eventId)
        .collection('Group')
        .document(eventGroupEntity.uid)
        .delete();
  }

  Future<List<EventGroupEntity>> getEventGroupEntity(String eventId) {
    return eventCollection
        .document(eventId)
        .collection('Group')
        .getDocuments()
        .then((snapshot) => snapshot.documents
            .map((result) => EventGroupEntity.fromSnapshot(result))
            .toList());
  }

  Future<void> updateEventGroupEntity(EventGroupEntity eventGroupEntity, String eventId) {
    return eventCollection
        .document(eventId)
        .collection('Group')
        .document(eventGroupEntity.uid)
        .updateData(eventGroupEntity.toDocument());
  }
}
