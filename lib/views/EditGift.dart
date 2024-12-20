import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';

class EditGiftPage extends StatefulWidget {
  final String giftId;
  final String initialName;
  final String initialCategory;
  final String initialPrice;
  final String initialDescription;

  const EditGiftPage({
    Key? key,
    required this.giftId,
    required this.initialName,
    required this.initialCategory,
    required this.initialPrice,
    required this.initialDescription,
  }) : super(key: key);

  @override
  _EditGiftPageState createState() => _EditGiftPageState();
}

class _EditGiftPageState extends State<EditGiftPage> {
  final _formKey = GlobalKey<FormState>();
  final GiftListController _controller = GiftListController();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _categoryController = TextEditingController(text: widget.initialCategory);
    _priceController = TextEditingController(text: widget.initialPrice);
    _descriptionController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Collect updated gift details
      final String id = widget.giftId;
      final String name = _nameController.text.trim();
      final String category = _categoryController.text.trim();
      final String description = _descriptionController.text.trim();
      final double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      try {
        // Call the controller to update the gift
        await _controller.updateGiftDetails(
          id,
          name,
          category,
          description,
          price,
        );

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gift updated successfully!')),
        );

        Navigator.pop(context, true); // Go back after saving
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update gift. Error: $e')),
        );
      }
    }
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
            'Edit Gift',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                labelText: 'Gift Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the gift name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _categoryController,
                labelText: 'Category',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                labelText: 'Price',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                labelText: 'Description',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color(0xFF2EC2D2),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
