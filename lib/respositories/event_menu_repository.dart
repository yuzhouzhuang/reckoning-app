// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/entities.dart';

class FirebaseEventMenuRepository {
  final CollectionReference eventCollection =
      Firestore.instance.collection('Events');

  Future<void> addNewEventMenuEntity(EventMenuEntity eventMenuEntity, String eventId) {
    return eventCollection
        .document(eventId)
        .collection('Menu')
        .add(eventMenuEntity.toDocument());
  }

  Future<void> deleteEventMenuEntity(
      EventMenuEntity eventMenuEntity, String eventId) async {
    return eventCollection
        .document(eventId)
        .collection('Menu')
        .document(eventMenuEntity.itemId)
        .delete();
  }

  Future<List<EventMenuEntity>> getEventMenuEntity(String eventId) {
    return eventCollection
        .document(eventId)
        .collection('Menu')
        .getDocuments()
        .then((snapshot) => snapshot.documents
            .map((result) => EventMenuEntity.fromSnapshot(result))
            .toList());
  }

  Future<void> updateEventMenuEntity(EventMenuEntity eventMenuEntity, String eventId) {
    return eventCollection
        .document(eventId)
        .collection('Menu')
        .document(eventMenuEntity.itemId)
        .updateData(eventMenuEntity.toDocument());
  }
}
