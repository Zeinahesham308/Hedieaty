import 'package:flutter/material.dart';

class FriendGiftDetailsPage extends StatelessWidget {
  final Map<String, dynamic> gift; // Gift details passed as a map

  const FriendGiftDetailsPage({Key? key, required this.gift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Details'),
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
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gift Image (Placeholder)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/default_gift.png', // Replace with dynamic image if available
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gift Title
                  Text(
                    gift['name'] ?? 'No Name',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Gift Details
                  _buildDetailRow(Icons.category, 'Category', gift['category'] ?? 'N/A'),
                  _buildDetailRow(Icons.description, 'Description', gift['description'] ?? 'No description'),
                  _buildDetailRow(Icons.attach_money, 'Price', '\$${gift['price'] ?? 0.0}'),
                  _buildDetailRow(Icons.check_circle, 'Status', gift['status'] ?? 'N/A'),

                  const SizedBox(height: 20),

                  // Pledge Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement pledge logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pledged for this gift!')),
                      );
                    },
                    icon: const Icon(Icons.handshake, color: Colors.white),
                    label: const Text(
                      'Pledge Gift',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widget to display each detail row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}