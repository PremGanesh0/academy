import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    List<Map<String, dynamic>> notifications = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('read', isEqualTo: false)
          .get();
      for (var doc in querySnapshot.docs) {
        String uid = doc.get('uid');
        String message = doc.get('message');
        notifications.add({
          'uid': uid,
          'message': message,
        });
        // Mark the notification as read
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(doc.id)
            .update({'read': true});
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    }

    return notifications;
  }

  Future<Map<String, dynamic>> getParentData(String uid) async {
    Map<String, dynamic> parentData = {};
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance.collection('parents').doc(uid).get();
      parentData = docSnapshot.data() ?? {};
    } catch (error) {
      print('Error fetching parent data: $error');
    }

    return parentData;
  }

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
          'Notifications',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
          children: [
            const SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getAllNotifications(),
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
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> notification = snapshot.data![index];
                        return FutureBuilder<Map<String, dynamic>>(
                          future: getParentData(notification['uid']),
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
                              Map<String, dynamic> parentData = snapshot.data!;
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage('assets/profile_image.png'),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              Text(
                                                parentData['name'] ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                notification['message'] ?? 'No message',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 25,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 60),
                                              child: FutureBuilder<
                                                  DocumentSnapshot<Map<String, dynamic>>>(
                                                future: FirebaseFirestore.instance
                                                    .collection('students')
                                                    .doc(parentData['studentId'])
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text('Error: ${snapshot.error}'),
                                                    );
                                                  } else if (!snapshot.hasData) {
                                                    return const Text('No data available');
                                                  } else {
                                                    Map<String, dynamic> studentData =
                                                        snapshot.data!.data() ?? {};
                                                    return Text(
                                                      '${studentData['name'] ?? 'Unknown'}, ${studentData['classId'] ?? 'Unknown'}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
