import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';
import 'bottom_nav_bar.dart';
import 'addGift.dart';
import 'GiftDetails.dart';
import 'EditGift.dart';

class GiftListPage extends StatefulWidget {
  final String userId;
  final String eventId;

  const GiftListPage({Key? key, required this.userId, required this.eventId}) : super(key: key);

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftListController _controller = GiftListController();
  List<Map<String, dynamic>> _gifts = [];
  final List<String> _validSortValues = ['name', 'category', 'status'];
  String _selectedSort = 'name'; // Default sort option
  String _eventName = ''; // Event name to display in AppBar

  @override
  void initState() {
    super.initState();
    _loadEventName();
    _loadGifts();
  }

  Future<void> _loadEventName() async {
    try {
      final name = await _controller.fetchEventName(widget.eventId);
      setState(() {
        _eventName = name;
      });
    } catch (e) {
      print('Error fetching event name: $e');
    }
  }


  Future<void> _loadGifts() async {
    try {
      final gifts = await _controller.fetchGiftsForEvent(widget.eventId);
      setState(() {
        _gifts = gifts.toList(); // Make a mutable copy
        _sortGifts(_selectedSort); // Sort gifts after loading
      });
    } catch (e) {
      print('Error loading gifts: $e');
    }
  }

  void _sortGifts(String criteria) {
    if (!_validSortValues.contains(criteria)) {
      print('Invalid sort criteria: $criteria');
      return;
    }

    setState(() {
      switch (criteria) {
        case 'name':
          _gifts = _controller.sortGiftsByName(_gifts);
          break;
        case 'category':
          _gifts = _controller.sortGiftsByCategory(_gifts);
          break;
        case 'status':
          _gifts = _controller.sortGiftsByStatus(_gifts);
          break;
      }
      _selectedSort = criteria;
    });
  }

  void _addNewGift() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddGiftPage(eventId: widget.eventId)),
    ).then((_) => _loadGifts());
  }

  void _editGift(Map<String, dynamic> gift) async {
    if (gift['status'] != 'Available') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only available gifts can be edited.')),
      );
      return;
    }

    final updatedGift = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditGiftPage(
              giftId: gift['id'],
              initialName: gift['name'],
              initialCategory: gift['category'],
              initialPrice: gift['price'].toString(),
              initialDescription: gift['description'],
            ),
      ),
    );

    if (updatedGift != null) {
      await _loadGifts();
    }
  }

  void _deleteGift(String giftId) {
    print("Deleting Gift with ID: $giftId");
    // Add delete logic here if needed
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
          title: Text(
            '$_eventName Gift List',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _validSortValues.contains(_selectedSort)
                      ? _selectedSort
                      : 'name',
                  items: const [
                    DropdownMenuItem(
                        value: 'name', child: Text('Sort by Name')),
                    DropdownMenuItem(
                        value: 'category', child: Text('Sort by Category')),
                    DropdownMenuItem(
                        value: 'status', child: Text('Sort by Status')),
                  ],
                  onChanged: (value) => _sortGifts(value!),
                  hint: const Text('Sort By'),
                ),
                ElevatedButton.icon(
                  onPressed: _addNewGift,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                      'Add Gift', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC2D2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _gifts.isEmpty
                ? const Center(
                child: Text('No gifts available for this event.'))
                : ListView.builder(
              itemCount: _gifts.length,
              itemBuilder: (context, index) {
                final gift = _gifts[index];
                return _buildGiftCard(gift);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        userId: widget.userId,
      ),
    );
  }

  Widget _buildGiftCard(Map<String, dynamic> gift) {
    final isPledged = gift['status'] == 'Pledged';

    // Fetch the gift status dynamically
    return FutureBuilder<String>(
      future: _controller.getGiftStatus(gift['id'], gift['event_id']),
      // Fetch status dynamically
      builder: (context, snapshot) {
        final status = snapshot.data ??
            gift['status']; // Use fetched status or fallback to the current one
        final isPledgedDynamic = status == 'Pledged';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error fetching status');
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    GiftDetailsPage(
                      giftName: gift['name'],
                      description: gift['description'],
                      category: gift['category'],
                      price: gift['price'],
                      status: status, // Use the dynamically fetched status
                    ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gift['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.category, color: Colors.black),
                          const SizedBox(width: 5),
                          Text('Category: ${gift['category']}',
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Colors.black),
                          const SizedBox(width: 5),
                          Text('Price: \$${gift['price']}',
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.black),
                          const SizedBox(width: 5),
                          Text(
                            'Status: $status',
                            // Display dynamically fetched status
                            style: TextStyle(
                              color: isPledgedDynamic ? Colors.green : Colors
                                  .black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editGift(gift);
                    } else if (value == 'delete') {
                      _deleteGift(gift['id']);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      if (status == 'Available')
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit, color: Colors.blue),
                            title: Text('Edit Gift'),
                          ),
                        ),
                      if (status == 'Available')
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Delete Gift'),
                          ),
                        ),
                      if (status != 'Available')
                        PopupMenuItem<String>(
                          enabled: false,
                          child: ListTile(
                            leading: Icon(Icons.block, color: Colors.grey),
                            title: Text('Edit/Delete Disabled'),
                          ),
                        ),
                    ];
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}