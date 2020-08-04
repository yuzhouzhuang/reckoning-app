import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/entities.dart';
import '../respositories/respositories.dart';

class UserEventLogic {
  final FirebaseUserEventRepository eventInfoRepository =
      FirebaseUserEventRepository();

  Future<void> addNewUserEvent(String eventId, String uid, int acceptType,
      Timestamp eventDate, double paymentAmount) {
    return eventInfoRepository.addNewUserEventEntity(
        UserEventEntity(eventId, acceptType, eventDate, paymentAmount), uid);
  }

  Future<List<Map<String, Object>>> getUserEventEntity(String eventId) {
    return eventInfoRepository
        .getUserEventEntity(eventId)
        .then((value) => value.map((e) => e.toJson()).toList());
  }

  Future<void> updateEventGroup(String eventId, String uid, int acceptType,
      Timestamp eventDate, double paymentAmount) {
    return eventInfoRepository.updateUserEventEntity(
        UserEventEntity(eventId, acceptType, eventDate, paymentAmount), uid);
  }
}
