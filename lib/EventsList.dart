import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'GiftsList.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

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
                colors: [
                  Color(0xFFFFC107),
                  Color(0xFF2EC2D2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'My Events',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sort By Dropdown and Add Event Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'name',
                      child: Text('Name'),
                    ),
                    DropdownMenuItem(
                      value: 'category',
                      child: Text('Category'),
                    ),
                    DropdownMenuItem(
                      value: 'status_upcoming',
                      child: Text('Status (Upcoming)'),
                    ),
                  ],
                  onChanged: (value) {
                    // Handle sorting logic
                  },
                  hint: const Text(
                    'Sort by',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => AddEventBottomSheet(),
                    );
                  },
                  child: const Text('Add Event'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return EventCard(
                    eventName: "My Event $index",
                    eventDate: '30 Aug 2025',
                    status: 'Upcoming',
                    onEdit: () {
                      // Handle edit logic
                    },
                    onDelete: () {
                      // Handle delete logic
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    //  bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventCard({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.status,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GiftListPage(eventName: eventName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(eventDate, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(status, style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddEventBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text('Add Event Form Here'),
    );
  }
}
