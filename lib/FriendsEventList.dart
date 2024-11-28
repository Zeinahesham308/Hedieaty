import 'package:flutter/material.dart';
import 'FriendsGiftList.dart'; // Import FriendsGiftList page

class FriendsEventListPage extends StatelessWidget {
  final String friendName;

  const FriendsEventListPage({Key? key, required this.friendName})
      : super(key: key);

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
            '$friendName\'s Events',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Available Events',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Event List
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Number of events
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to FriendsGiftListPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendsGiftListPage(
                            eventName: "Event ${index + 1}", // Pass event name
                            friendName: friendName, // Pass friend's name
                          ),
                        ),
                      );
                    },
                    child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Event Details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Event ${index + 1}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "30 Aug 2025", // Placeholder date
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        ],
                      ),
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
