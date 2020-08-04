import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/entities.dart';
import '../respositories/respositories.dart';

class EventLogic {
  final FirebaseEventInfoRepository eventInfoRepository = FirebaseEventInfoRepository();

  Future<void> addNewEvent(String eventName, String ownerId, double totalValue, Timestamp eventDate) {
    return eventInfoRepository.addNewEventEntity(EventEntity("", eventName, ownerId, totalValue, eventDate));
  }

  Future<Map<String, Object>> getEventEntity(String eventId) {
    return eventInfoRepository.getEventEntity(eventId).then((value) => value.toJson());
  }

  Future<void> updateEvent(String eventId, String eventName, String ownerId, double totalValue, Timestamp eventDate) {
    return eventInfoRepository.updateEventEntity(EventEntity(eventId, eventName, ownerId, totalValue, eventDate));
  }
}
