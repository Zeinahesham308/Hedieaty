import 'package:flutter/material.dart';
import 'controllers/gift_list_controller.dart';
import 'bottom_nav_bar.dart';

class PledgedGiftsPage extends StatefulWidget {
  final String userId;

  const PledgedGiftsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  final GiftListController _controller = GiftListController();
  List<Map<String, dynamic>> _pledgedGifts = [];

  @override
  void initState() {
    super.initState();
    _loadPledgedGifts();
  }

  Future<void> _loadPledgedGifts() async {
    try {
      final gifts = await _controller.fetchPledgedGifts(widget.userId);
      setState(() {
        _pledgedGifts = gifts;
      });
    } catch (e) {
      print('Error fetching pledged gifts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Pledged Gifts',
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
        child: _pledgedGifts.isEmpty
            ? const Center(
          child: Text(
            'No pledged gifts yet.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        )
            : ListView.builder(
          itemCount: _pledgedGifts.length,
          itemBuilder: (context, index) {
            final gift = _pledgedGifts[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  gift['name'] ?? 'No Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Event: ${gift['eventName'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      "friend: ${gift['friendName'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      "Due Date: ${gift['eventDate'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
                contentPadding: const EdgeInsets.all(0),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        userId: widget.userId,
      ),
    );
  }
}
