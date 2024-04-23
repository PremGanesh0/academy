import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotifyHistory extends StatelessWidget {
  const NotifyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFBD2),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Add functionality to go back
          },
        ),
        title: const Text(
          'Notify History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center the title in the appBar
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove app bar elevation
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final notifications = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final message = notification['message'];
                  final timestamp = notification['timestamp'];
                  final read = notification['read'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              Text(
                                timestamp.toDate().toString(), // Convert timestamp to readable date
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            message,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
