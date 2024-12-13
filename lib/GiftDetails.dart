import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class GiftDetailsPage extends StatelessWidget {
  final String giftName;
  final String description;
  final String category;
  final double price;
  final String status; // "Available" or "Pledged"

  const GiftDetailsPage({
    Key? key,
    required this.giftName,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController giftNameController =
    TextEditingController(text: giftName);
    final TextEditingController descriptionController =
    TextEditingController(text: description);
    final TextEditingController categoryController =
    TextEditingController(text: category);
    final TextEditingController priceController =
    TextEditingController(text: price.toString());
    bool isPledged = status == "Pledged";

    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        title: const Text(
          "Gift Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gift Name Field
              const Text("Gift Name", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: giftNameController,
                readOnly: isPledged,
                decoration: InputDecoration(
                  hintText: "Enter gift name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                readOnly: isPledged,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Field
              const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                readOnly: isPledged,
                decoration: InputDecoration(
                  hintText: "Enter category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Price Field
              const Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                readOnly: isPledged,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Upload Image Section
              const Text("Gift Image", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: isPledged
                    ? null
                    : () {
                  // Handle image upload logic
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      isPledged ? "Image cannot be modified" : "Tap to upload image",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status Toggle
              const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: "Available", child: Text("Available")),
                  DropdownMenuItem(value: "Pledged", child: Text("Pledged")),
                ],
                onChanged: isPledged
                    ? null
                    : (value) {
                  // Handle status change
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: isPledged
                      ? null
                      : () {
                    // Handle save logic here
                    Navigator.pop(context); // Return to Gift List Page
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor:
                    isPledged ? Colors.grey : const Color(0xFF2EC2D2),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //  bottomNavigationBar: const BottomNavBar(selectedIndex: 2)
    );
  }
}
