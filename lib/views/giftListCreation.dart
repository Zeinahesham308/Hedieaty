import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';
import 'package:hedieaty/views/GiftsList.dart';
class GiftListCreationPage extends StatefulWidget {
  final String userId;

  const GiftListCreationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _GiftListCreationPageState createState() => _GiftListCreationPageState();
}

class _GiftListCreationPageState extends State<GiftListCreationPage> {
  String? _selectedEventId; // Event ID of the selected event
  Map<String, String> _eventMap = {}; // Map to store eventId -> eventName
  final GiftListController _controller = GiftListController();

  @override
  void initState() {
    super.initState();
    _loadEventNames(); // Fetch event names when the page loads
  }

  Future<void> _loadEventNames() async {
    final events = await _controller.fetchEventNames(widget.userId);
    setState(() {
      _eventMap = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown Menu
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Select Event',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedEventId,
                  hint: const Text('Choose an event'),
                  items: _eventMap.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEventId = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Button to Navigate
            ElevatedButton(
              onPressed: () {
                if (_selectedEventId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an event to proceed.'),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GiftListPage(
                        userId: widget.userId,
                        eventId: _selectedEventId!,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC2D2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Navigate to Gift List',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

