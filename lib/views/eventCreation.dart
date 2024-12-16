import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';

class EventCreationPage extends StatefulWidget {
  final String userId;

  const EventCreationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final EventController _controller = EventController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _createEvent() async {
    if (_nameController.text.isEmpty || _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event name and date are required!')),
      );
      return;
    }

    await _controller.createEvent(
      name: _nameController.text,
      date: _dateController.text,
      location: _locationController.text,
      description: _descriptionController.text,
      userId: widget.userId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputField('Event Name', 'Enter event name', _nameController),
              _buildInputField('Event Date', 'Enter date (YYYY-MM-DD)', _dateController),
              _buildInputField('Location', 'Enter location', _locationController),
              _buildInputField('Description', 'Enter description', _descriptionController),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC2D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'Create Event',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
