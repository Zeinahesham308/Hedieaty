import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';
import '../bottom_nav_bar.dart';

class AddGiftPage extends StatefulWidget {
  final String eventId;

  const AddGiftPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _AddGiftPageState createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  final GiftListController _controller = GiftListController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedCategory;
  List<String> _categories = [];
  String _defaultImagePath = 'assets/images/default_gift.png'; // Default image path
  String _currentImagePath = ''; // To simulate "uploaded" image path

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _currentImagePath = ''; // Initialize with the default image
  }

  Future<void> _fetchCategories() async {
    final categories = await _controller.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _simulateImageUpload() {
    // Simulate image upload by resetting to the default image
    setState(() {
      _currentImagePath = _defaultImagePath;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image "uploaded" successfully!')),
    );
  }

  void _addGift() async {
    if (_nameController.text.isEmpty || _selectedCategory == null ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    await _controller.addGift(
      name: _nameController.text,
      description: _descriptionController.text,
      category: _selectedCategory!,
      price: double.tryParse(_priceController.text) ?? 0.0,
      eventId: widget.eventId, // Pass the "uploaded" default image
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gift added successfully!')),
    );
    Navigator.pop(context); // Return to the previous page
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
            'Add Gift',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputField('Gift Name', 'Enter gift name', _nameController),
              _buildInputField(
                  'Description', 'Enter description', _descriptionController,
                  isMultiline: true),
              _buildDropdownMenu(),
              _buildInputField(
                  'Price', 'Enter price', _priceController, isNumeric: true),
              _buildImagePicker(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addGift,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC2D2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('Add to List',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
          selectedIndex: 2, userId: widget.eventId),
    );
  }

  Widget _buildInputField(String label, String hint,
      TextEditingController controller,
      {bool isNumeric = false, bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        maxLines: isMultiline ? 3 : 1,
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

  Widget _buildDropdownMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Category',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategory,
            hint: const Text('Select a category'),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        // Show placeholder if no image is uploaded
        _currentImagePath.isEmpty
            ? Image.asset(
          'assets/images/default_gift.png', // Placeholder image path
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        )
            : Image.asset(
          _currentImagePath, // Uploaded or default image
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _simulateImageUpload,
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          label: const Text('Upload Image', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2EC2D2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
