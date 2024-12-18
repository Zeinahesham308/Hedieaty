import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';
import '../bottom_nav_bar.dart';
import 'eventCreation.dart';

class EventListPage extends StatefulWidget {
  final String userId;

  const EventListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventController _controller = EventController();
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await _controller.fetchEvents(widget.userId);
    setState(() {
      _events = events;
    });
  }

  void _openEventCreationPage() {
    showModalBottomSheet(
      isScrollControlled: false, // Allow for a full modal bottom sheet
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: EventCreationPage(userId: widget.userId),
        );
      },
    ).then((_) => _loadEvents()); // Reload events after returning
  }

  void _showDescription(String description) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Event Description'),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  void _editEvent(Map<String, dynamic> event) {
    TextEditingController nameController = TextEditingController(text: event['name']);
    TextEditingController dateController = TextEditingController(text: event['date']);
    TextEditingController locationController = TextEditingController(text: event['location']);
    TextEditingController descriptionController = TextEditingController(text: event['description']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Event'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _controller.updateEvent(
                id: event['id'],
                name: nameController.text,
                date: dateController.text,
                location: locationController.text,
                description: descriptionController.text,
              );
              Navigator.pop(context);
              _loadEvents();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(String eventId) async {
    await _controller.deleteEvent(eventId);
    _loadEvents();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Event List',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // "Add New Event" button aligned to the right
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [DropdownButton<String>(
                items: const [
                  DropdownMenuItem(
                    value: 'name',
                    child: Text(
                      'Sort by Name',
                      style: TextStyle(color: Color(0xFF2EC2D2), fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'status',
                    child: Text(
                      'Sort by Status',
                      style: TextStyle(color: Color(0xFF2EC2D2), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                dropdownColor: Colors.white, // Background color of the dropdown menu
                style: const TextStyle(
                  color: Color(0xFF2EC2D2), // Text color of the button
                  fontWeight: FontWeight.bold,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF2EC2D2), // Dropdown icon color
                ),
                onChanged: (value) {
                  if (value == 'name') {
                    setState(() {
                      _events = _controller.sortEventsByName(_events);
                    });
                  } else if (value == 'status') {
                    setState(() {
                      _events = _controller.sortEventsByStatus(_events);
                    });
                  }
                },
                hint: const Text(
                  'Sort By',
                  style: TextStyle(color: Color(0xFF2EC2D2), fontWeight: FontWeight.bold),
                ),
                underline: Container(
                  height: 2,
                  color: Color(0xFF2EC2D2), // Underline color
                ),
              ),

                    ElevatedButton.icon(
                      onPressed: _openEventCreationPage,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add New Event',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC2D2),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),

          ),

          // Event List
          Expanded(
            child: _events.isEmpty
                ? const Center(
              child: Text(
                'No events available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                final status = _controller.getEventStatus(event['date']);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.black),
                                const SizedBox(width: 4),
                                Text(event['location']),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.black),
                                const SizedBox(width: 4),
                                Text(event['date']),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                _buildStatusChip('Past', status == 'Past'),
                                _buildStatusChip('Current', status == 'Current'),
                                _buildStatusChip('Upcoming', status == 'Upcoming'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'Publish') {
                            // Call the publishGiftList functionality here
                            await _controller.publishGiftList(event['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gift list published successfully to friends!'),
                              ),
                            );
                          } else if (value == 'Delete') {
                            _deleteEvent(event['id']); // Example of another action
                          }

                          else if (value=='Edit')
                            {
                              _editEvent(event);
                            }
                          else if (value=='Description')
                            {
                              _showDescription(event['description']);
                            }
                        },

                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<String>(
                              value: 'Description',
                              child: ListTile(
                                leading: Icon(Icons.info, color: Colors.blue),
                                title: Text('Description'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Edit',
                              child: ListTile(
                                leading: Icon(Icons.edit, color: Colors.blue),
                                title: Text('Edit'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Delete',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete Event'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Publish',
                              child: ListTile(
                                leading: Icon(Icons.publish, color: Colors.green),
                                title: Text('Publish to Friends'),
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        userId: widget.userId,
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey,),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
