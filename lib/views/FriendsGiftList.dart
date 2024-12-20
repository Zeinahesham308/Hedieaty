import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';
import '../controllers/notification_controller.dart';
import 'friendGiftDetails.dart';

class FriendsGiftListPage extends StatefulWidget {
  final String eventName; // Event name
  final String friendName; // Friend name
  final String eventId; // Event ID to fetch gifts
  final String userId; // Current user ID

  const FriendsGiftListPage({
    Key? key,
    required this.eventName,
    required this.friendName,
    required this.eventId,
    required this.userId,
  }) : super(key: key);

  @override
  _FriendsGiftListPageState createState() => _FriendsGiftListPageState();
}

class _FriendsGiftListPageState extends State<FriendsGiftListPage> {
  final GiftListController _controller = GiftListController();
  List<Map<String, dynamic>> _gifts = [];

  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }
  // void sendPledgeNotification(String giftOwnerId, String pledgerId, String giftName) {
  //   final String message = "User has pledged your gift: $giftName";
  //   NotificationController.addNotification(
  //     message: message,
  //     receiverId: giftOwnerId,
  //     senderId: pledgerId,
  //     type: 'gift_pledged',
  //   );
  // }

  Future<void> _fetchGifts() async {
    try {
      final gifts = await _controller.retrieveGifts(widget.eventId);
      setState(() {
        _gifts = gifts;
      });
    } catch (e) {
      print('Error fetching gifts: $e');
    }
  }

  Future<void> _updateGiftStatus(String giftId, String newStatus) async {
    try {
      await _controller.updateGiftStatus(giftId, newStatus, widget.userId,widget.eventId);
      await _fetchGifts();
    } catch (e) {
      print('Error updating gift status: $e');
    }
  }

  Color _getBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.blueAccent;
      case 'pledged':
        return Colors.green;
      case 'purchased':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  Widget _getActionButton(String giftId, String status, String pledgedBy) {
    if (status.toLowerCase() == 'available') {
      print("WALLAHE ?")
;      return ElevatedButton(
        onPressed: () => _updateGiftStatus(giftId, 'pledged'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        child: const Text(
          "Pledge",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else if (status.toLowerCase() == 'pledged' && pledgedBy == widget.userId) {
      return ElevatedButton(
        onPressed: () => _updateGiftStatus(giftId, 'purchased'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        child: const Text(
          "Purchase",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    return const SizedBox(); // No action button for purchased gifts or pledged gifts by others.
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
          backgroundColor: Colors.transparent,
          title: Text(
            '${widget.friendName}\'s ${widget.eventName} Gifts',
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
        child: _gifts.isEmpty
            ? const Center(child: Text('No gifts available for this event.'))
            : ListView.builder(
          itemCount: _gifts.length,
          itemBuilder: (context, index) {
            final gift = _gifts[index];
            final borderColor = _getBorderColor(gift['status'] ?? '');

            return GestureDetector(
              onTap: () {
                // Navigate to gift details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendGiftDetailsPage(gift: gift),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gift['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Category: ${gift['category'] ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Status: ${gift['status'] ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 14,
                            color: borderColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    _getActionButton(
                      gift['id'],
                      gift['status'] ?? '',
                      gift['pledgedBy'] ?? '',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
