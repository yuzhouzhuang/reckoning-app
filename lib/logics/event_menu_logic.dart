import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/entities.dart';
import '../respositories/respositories.dart';

class MenuLogic {
  final FirebaseEventMenuRepository eventInfoRepository =
      FirebaseEventMenuRepository();

  Future<void> addNewMenu(
      String eventId, String itemName, int itemType, double itemValue) {
    return eventInfoRepository.addNewEventMenuEntity(
        EventMenuEntity("", itemName, itemType, itemValue), eventId);
  }

  Future<void> deleteMenu(String eventId, String itemId) {
    return eventInfoRepository.deleteEventMenuEntity(
        EventMenuEntity(itemId, "", 0, 0), eventId);
  }

  Future<List<Map<String, Object>>> getEventMenuEntity(String eventId) {
    return eventInfoRepository
        .getEventMenuEntity(eventId)
        .then((value) => value.map((e) => e.toJson()).toList());
  }

  Future<void> updateEventMenu(String eventId, String itemId, String itemName,
      int itemType, double itemValue) {
    return eventInfoRepository.updateEventMenuEntity(
        EventMenuEntity(itemId, itemName, itemType, itemValue), eventId);
  }
}
