// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/entities.dart';

class FirebaseUserInfoRepository {
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  Future<void> addNewUserEntity(UserEntity userEntity) {
    return userCollection.document(userEntity.uid).setData(userEntity.toDocument());
  }

  Future<void> deleteUserEntity(UserEntity userEntity) async {
    return userCollection.document(userEntity.uid).delete();
  }

  Future<bool> hasUser(String uid) async {
    List<String> list = await userCollection.getDocuments().then((snapshot) => snapshot.documents
        .map((result) => result.documentID)
        .toList());
    return list.contains(uid);
  }

  Future<UserEntity> getUserEntity(String uid) {
    return userCollection.document(uid).get().then((snapshot) {
      return UserEntity.fromSnapshot(snapshot);
    });
  }

  Future<void> updateUserEntity(UserEntity userEntity) {
    return userCollection
        .document(userEntity.uid)
        .updateData(userEntity.toDocument());
  }
}
