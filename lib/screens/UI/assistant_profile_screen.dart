import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurseryapplication_/screens/UI/welcome_screen.dart';
import 'package:nurseryapplication_/screens/widgets/announcement.dart';
import 'package:nurseryapplication_/screens/widgets/notifications.dart';
import 'package:nurseryapplication_/screens/widgets/teacher_postannouncement.dart';

class AssistantProfile extends StatefulWidget {
  const AssistantProfile({super.key});

  @override
  State<AssistantProfile> createState() => _AssistantProfileState();
}

class _AssistantProfileState extends State<AssistantProfile> {
  File? image;
  Future<void> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  String? profileImage;
  String? name;
  User? firebaseauth;
  @override
  initState() {
    super.initState();
    firebaseauth = FirebaseAuth.instance.currentUser;
    getUserData();
  }

// write a function to get the total number of notifications from the database
  Future<String?> getNotifications() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();
    return querySnapshot.docs.length.toString();
  }

  // Stream<int> getNotificationStream() async* {
  //   while (true) {
  //     // Emit the number of notifications periodically
  //     yield int.tryParse(await getNotifications()) ?? 0;
  //     await Future.delayed(const Duration(seconds: 10)); // Adjust the duration as needed
  //   }
  // }

  Future<void> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('assistants').doc(firebaseauth!.uid).get();
    setState(() {
      profileImage = documentSnapshot.data()!['imageUrl'];
      name = documentSnapshot.data()!['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFFFBD2),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: CircleAvatar(
                    // Replace the placeholder AssetImage with the actual image asset
                    backgroundImage: NetworkImage(profileImage ?? 'assets/profile.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  name ?? 'Name',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Center(
                    child: Container(
                      height: 45,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff47E197), width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff2BC67B),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width, 0),
                            backgroundColor: const Color(0xff47E197),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0))),
                          ),
                          child: const Text(
                            "Post Announcements",
                            style: TextStyle(
                                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            popUpForPostAnnouncements();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Center(
                    child: Container(
                      height: 45,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffFFFBD2), width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffD2CEAE),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width, 0),
                            backgroundColor: const Color(0xffFFFBD2),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0))),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Notifications",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              const SizedBox(width: 8),
                              FutureBuilder<String?>(
                                future:
                                    getNotifications(), // Replace with the actual notification count
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      height: 25,
                                      width: 25,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          snapshot.data!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error: ${snapshot.error}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(); // Placeholder for loading state
                                  }
                                },
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Notifications()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Center(
                    child: Container(
                      height: 45,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffFFFBD2), width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffD2CEAE),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width, 0),
                            backgroundColor: const Color(0xffFFFBD2),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0))),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                "Announcements",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Announcement()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Center(
                    child: Container(
                      height: 45,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffFFFBD2), width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffD2CEAE),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width, 0),
                            backgroundColor: const Color(0xffFFFBD2),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0))),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Welcome()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  popUpForPostAnnouncements() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TeacherPostAnnouncementPopup();
      },
    );
  }
}
