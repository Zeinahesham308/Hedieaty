import 'package:flutter/material.dart';

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
              const Text(
                "Gift Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: giftNameController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                readOnly: true,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Field
              const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Price Field
              const Text(
                "Price",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Upload Image Section
              const Text(
                "Gift Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Image cannot be modified",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status Display
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: status),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),


            ],
          ),
        ),
      ),
    );
  }
}
