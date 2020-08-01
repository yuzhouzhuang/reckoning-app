// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'entities/entities.dart';

class FirebaseUserInfoRepository{
  final userCollection = Firestore.instance.collection('Users');

  Future<void> addNewUserEntity(UserEntity userEntity) {
    return userCollection.add(userEntity.toDocument());
  }

  Future<void> deleteUserEntity(UserEntity userEntity) async {
    return userCollection.document(userEntity.uid).delete();
  }

  Stream<List<UserEntity>> getUserEntities() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => UserEntity.fromSnapshot(doc))
          .toList();
    });
  }

  Future<void> updateUserEntity(UserEntity userEntity) {
    return userCollection
        .document(userEntity.uid)
        .updateData(userEntity.toDocument());
  }
}