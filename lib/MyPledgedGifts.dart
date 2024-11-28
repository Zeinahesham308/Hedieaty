import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  const MyPledgedGiftsPage({Key? key}) : super(key: key);

  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  // Sample data for pledged gifts
  final List<Map<String, String>> pledgedGifts = [
    {
      "giftName": "Gift 1",
      "friendName": "Friend 1",
      "dueDate": "30 Aug 2025",
      "status": "Pending",
    },
    {
      "giftName": "Gift 2",
      "friendName": "Friend 2",
      "dueDate": "15 Sep 2025",
      "status": "Completed",
    },
    {
      "giftName": "Gift 3",
      "friendName": "Friend 3",
      "dueDate": "10 Oct 2025",
      "status": "Pending",
    },
  ];

  void modifyPledge(int index) {
    // Handle modification logic here
    setState(() {
      pledgedGifts[index]['status'] = 'Modified';
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
          title: const Text(
            'My Pledged Gifts',
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pledgedGifts.length,
                itemBuilder: (context, index) {
                  return PledgedGiftCard(
                    giftName: pledgedGifts[index]['giftName']!,
                    friendName: pledgedGifts[index]['friendName']!,
                    dueDate: pledgedGifts[index]['dueDate']!,
                    status: pledgedGifts[index]['status']!,
                    onModify: pledgedGifts[index]['status'] == 'Pending'
                        ? () => modifyPledge(index)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}

class PledgedGiftCard extends StatelessWidget {
  final String giftName;
  final String friendName;
  final String dueDate;
  final String status;
  final VoidCallback? onModify;

  const PledgedGiftCard({
    Key? key,
    required this.giftName,
    required this.friendName,
    required this.dueDate,
    required this.status,
    this.onModify,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            giftName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Friend: $friendName',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Due Date: $dueDate',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(
                  status,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: status == 'Pending' ? Colors.orange : Colors.green,
              ),
              if (onModify != null)
                ElevatedButton(
                  onPressed: onModify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Modify'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
