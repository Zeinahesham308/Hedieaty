import 'package:flutter/material.dart';
import 'package:hedieaty/GiftDetails.dart';
class GiftListPage extends StatefulWidget {
  final String eventName;

  const GiftListPage({Key? key, required this.eventName}) : super(key: key);

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  List<Map<String, String>> gifts = [
    {"name": "Gift 1", "category": "Category 1", "status": "Available"},
    {"name": "Gift 2", "category": "Category 2", "status": "Pledged"},
    {"name": "Gift 3", "category": "Category 3", "status": "Available"},
  ];

  void addGift(String name, String category, String status) {
    setState(() {
      gifts.add({"name": name, "category": category, "status": status});
    });
  }

  void editGift(int index, String name, String category, String status) {
    setState(() {
      gifts[index] = {"name": name, "category": category, "status": status};
    });
  }

  void deleteGift(int index) {
    setState(() {
      gifts.removeAt(index);
    });
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
          title: Text(
            '${widget.eventName} - Gifts',
            style: const TextStyle(
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
            // Sort By Dropdown and Add Gift Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort By Dropdown
                DropdownButton<String>(
                  underline: const SizedBox(), // Remove default underline
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
                      value: 'status',
                      child: Text('Status'),
                    ),
                  ],
                  onChanged: (value) {
                    // Handle sorting logic here
                  },
                  hint: const Text(
                    'Sort by',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

                // Add Gift Button
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => AddEditGiftBottomSheet(
                        onSubmit: addGift,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    shadowColor: Colors.grey.withOpacity(0.5),
                    elevation: 4, // Subtle shadow
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add, // Plus icon
                        color: Colors.black, // Icon color
                        size: 20, // Icon size
                      ),
                      SizedBox(width: 8), // Space between icon and text
                      Text(
                        'Add Gift',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List of Gift Cards
            Expanded(
              child: ListView.builder(
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to GiftDetailsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiftDetailsPage(
                            giftName: gifts[index]['name']!,
                            description: "Sample Description", // Replace with actual data
                            category: gifts[index]['category']!,
                            price: 50.0, // Replace with actual data
                            status: gifts[index]['status']!,
                          ),
                        ),
                      );
                    },
                    child: GiftCard(
                      giftName: gifts[index]['name']!,
                      category: gifts[index]['category']!,
                      status: gifts[index]['status']!,
                      onEdit: gifts[index]['status'] == 'Pledged'
                          ? null
                          : () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => AddEditGiftBottomSheet(
                            initialName: gifts[index]['name'],
                            initialCategory: gifts[index]['category'],
                            initialStatus: gifts[index]['status'],
                            onSubmit: (name, category, status) =>
                                editGift(index, name, category, status),
                          ),
                        );
                      },
                      onDelete: () {
                        deleteGift(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GiftCard extends StatelessWidget {
  final String giftName;
  final String category;
  final String status;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const GiftCard({
    Key? key,
    required this.giftName,
    required this.category,
    required this.status,
    this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFC107),
            Color(0xFF2EC2D2),
          ],
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
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  giftName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        status,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: status == "Pledged"
                          ? Colors.green
                          : Colors.orange, // Color-coded based on status
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit' && onEdit != null) onEdit!();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'edit',
                  enabled: onEdit != null,
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: onEdit == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class AddEditGiftBottomSheet extends StatelessWidget {
  final String? initialName;
  final String? initialCategory;
  final String? initialStatus;
  final Function(String name, String category, String status) onSubmit;

  AddEditGiftBottomSheet({
    Key? key,
    this.initialName,
    this.initialCategory,
    this.initialStatus,
    required this.onSubmit,
  }) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    _nameController.text = initialName ?? '';
    _categoryController.text = initialCategory ?? '';
    _selectedStatus = initialStatus;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gift Name', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _nameController),
          const SizedBox(height: 16),
          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _categoryController),
          const SizedBox(height: 16),
          const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            items: const [
              DropdownMenuItem(value: "Available", child: Text("Available")),
              DropdownMenuItem(value: "Pledged", child: Text("Pledged")),
            ],
            onChanged: (value) {
              _selectedStatus = value!;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onSubmit(
                _nameController.text,
                _categoryController.text,
                _selectedStatus!,
              );
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
