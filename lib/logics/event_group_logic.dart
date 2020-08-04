import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/entities.dart';
import '../respositories/respositories.dart';

class GroupLogic {
  final FirebaseEventGroupRepository eventInfoRepository = FirebaseEventGroupRepository();

  Future<void> addNewGroup(String eventId, String uid, int userType, double paidAmount) {
    return eventInfoRepository.addNewEventGroupEntity(EventGroupEntity(uid, userType, paidAmount), eventId);
  }

  Future<void> deleteGroup(String eventId, String uid) {
    return eventInfoRepository.deleteEventGroupEntity(
        EventGroupEntity(uid, 0, 0), eventId);
  }

  Future<List<Map<String, Object>>> getEventGroupEntity(String eventId) {
    return eventInfoRepository.getEventGroupEntity(eventId).then((value) => value.map((e) => e.toJson()).toList());
  }

  Future<void> updateEventGroup(String eventId, String uid, int userType, double paidAmount) {
    return eventInfoRepository.updateEventGroupEntity(EventGroupEntity(uid, userType, paidAmount), eventId);
  }
}
