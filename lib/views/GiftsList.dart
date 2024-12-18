import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';
import '../bottom_nav_bar.dart';
import 'addGift.dart';

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
  String _selectedSort = 'name'; // Default sort option
  String _eventName = ''; // Event name to display in AppBar

  @override
  void initState() {
    super.initState();
    _loadEventName();
    _loadGifts();
  }

  Future<void> _loadEventName() async {
    final name = await _controller.fetchEventName(widget.eventId);
    setState(() {
      _eventName = name;
    });
  }

  Future<void> _loadGifts() async {
    final gifts = await _controller.fetchGiftsForEvent(widget.eventId);
    setState(() {
      _gifts = gifts;
    });
  }

  void _sortGifts(String criteria) {
    setState(() {
      switch (criteria) {
        case 'name':
          _gifts.sort((a, b) => a['name'].compareTo(b['name']));
          break;
        case 'category':
          _gifts.sort((a, b) => a['category'].compareTo(b['category']));
          break;
        case 'status':
          _gifts.sort((a, b) => a['status'].compareTo(b['status']));
          break;
      }
      _selectedSort = criteria;
    });
  }

  void _addNewGift() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddGiftPage(eventId: widget.eventId)));
  }

  void _deleteGift(String giftId) {
    print("Deleting Gift with ID: $giftId");
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
                  value: _selectedSort,
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                    DropdownMenuItem(value: 'category', child: Text('Sort by Category')),
                    DropdownMenuItem(value: 'status', child: Text('Sort by Status')),
                  ],
                  onChanged: (value) => _sortGifts(value!),
                  hint: const Text('Sort By'),
                ),
                ElevatedButton.icon(
                  onPressed: _addNewGift,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Gift', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC2D2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _gifts.isEmpty
                ? const Center(child: Text('No gifts available for this event.'))
                : ListView.builder(
              itemCount: _gifts.length,
              itemBuilder: (context, index) {
                final gift = _gifts[index];
                return _buildGiftCard(gift); // Display gift cards properly
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

    return Container(
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
          // Gift Details
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
                    Text('Category: ${gift['category']}', style: const TextStyle(color: Colors.black)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.black),
                    const SizedBox(width: 5),
                    Text('Price: \$${gift['price']}', style: const TextStyle(color: Colors.black)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.black),
                    const SizedBox(width: 5),
                    Text(
                      'Status: ${gift['status']}',
                      style: TextStyle(
                        color: isPledged ? Colors.green : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Popup Menu for Options
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _deleteGift(gift['id']);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete Gift'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
