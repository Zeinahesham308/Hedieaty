import '../models/event_model.dart';
import 'package:uuid/uuid.dart';

class EventController {
  final _uuid = const Uuid();

  Future<void> createEvent({
    required String name,
    required String date,
    required String location,
    String? description,
    required String userId,
  }) async {
    final String eventId = _uuid.v4(); // Generate a unique ID
    final Event event = Event(
      id: eventId,
      name: name,
      date: date,
      location: location,
      description: description ?? '',
      userId: userId,
    );

    await event.addEvent(
      name: name,
      date: date,
      location: location,
      description: description,
      userId: userId,
    );
  }

  Future<List<Map<String, dynamic>>> fetchEvents(String userId) async {
    final Event event = Event(
      id: '', // Dummy ID, not required for fetching events
      name: '',
      date: '',
      location: '',
      userId: userId,
    );

    return await event.getEvents(userId);
  }

  String getEventStatus(String eventDate) {
    DateTime today = DateTime.now();
    DateTime event = DateTime.parse(eventDate);

    if (event.isBefore(today)) {
      return 'Past';
    } else if (event.year == today.year &&
        event.month == today.month &&
        event.day == today.day) {
      return 'Current';
    } else {
      return 'Upcoming';
    }
  }
  /// Update an existing event
  Future<void> updateEvent({
    required String id,
    required String name,
    required String date,
    required String location,
    String? description,
  }) async {
    final Event event = Event(
      id: id,
      name: name,
      date: date,
      location: location,
      description: description ?? '',
      userId: '', // Not required for updating
    );

    await event.updateEvent(
      id: id,
      name: name,
      date: date,
      location: location,
      description: description,
    );
  }
}
