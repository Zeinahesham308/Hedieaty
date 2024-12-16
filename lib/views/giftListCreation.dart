import 'package:flutter/material.dart';

class GiftListCreationPage extends StatefulWidget {
  final String userId;

  const GiftListCreationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _GiftListCreationPageState createState() => _GiftListCreationPageState();
}

class _GiftListCreationPageState extends State<GiftListCreationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _createGiftList() {
    if (_nameController.text.isEmpty || _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift name and category are required!')),
      );
      return;
    }

    // Placeholder for gift list creation logic
    print('Gift List Created!');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gift list created successfully!')),
    );
    Navigator.pop(context); // Return to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(70),
      //   child: AppBar(
      //     centerTitle: true,
      //     flexibleSpace: Container(
      //       decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         ),
      //       ),
      //     ),
      //     backgroundColor: Colors.transparent,
      //     title: const Text(
      //       'Create Gift List',
      //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputField('Gift Name', 'Enter gift name', _nameController),
              _buildInputField('Category', 'Enter gift category', _categoryController),
              _buildInputField('Description', 'Enter description', _descriptionController),
              _buildInputField('Price', 'Enter price', _priceController, isNumeric: true),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _createGiftList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC2D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'Create Gift List',
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

  Widget _buildInputField(String label, String hint, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
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
