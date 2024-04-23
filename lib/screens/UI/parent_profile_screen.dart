import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurseryapplication_/screens/UI/welcome_screen.dart';
import 'package:nurseryapplication_/screens/widgets/addUpdateVehicle.dart';
import 'package:nurseryapplication_/screens/widgets/announcement.dart';
import 'package:nurseryapplication_/screens/widgets/notify_history.dart';
import 'package:nurseryapplication_/screens/widgets/notify_pickup.dart';
import 'package:nurseryapplication_/screens/widgets/pop_updatestudentdetails.dart';
import 'package:nurseryapplication_/screens/widgets/popup_updateprofile.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class ParentProfile extends StatefulWidget {
  const ParentProfile({super.key});

  @override
  State<ParentProfile> createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  File? image;
  String? profileImage;
  String? name;
  User? firebaseauth;
  String? uid;
  @override
  initState() {
    super.initState();
    firebaseauth = FirebaseAuth.instance.currentUser;
    getUserData();
  }

  Future<void> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('parents').doc(firebaseauth!.uid).get();
    setState(() {
      profileImage = documentSnapshot.data()!['imageUrl'];
      name = documentSnapshot.data()!['name'];
      uid = documentSnapshot.data()!['uid'];
    });
  }

  Future<void> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  void didUpdateWidget(covariant ParentProfile oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getUserData();
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
                    backgroundImage: NetworkImage(profileImage ?? 'assets/profile_image.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: name != null
                    ? Text(
                        name!,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    : const SizedBox(),
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
                              offset: Offset(0, 2),
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
                            "Notify Pickup",
                            style: TextStyle(
                                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            checkParenthaschildornot().then((value) {
                              if (value == 'parent has child') {
                                popUpForNotifyPickup(uid: uid!);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('No Child Found'),
                                      content: const Text('Please add a child to notify pickup'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
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
                                "Update Profile",
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
                            popUpForUpdateProfile();
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
                                "Update Child Profile",
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
                            popUpForUpdateStudentDetails();
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
                                "Add/Update Vehicle",
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
                            popUpForAddupdateVehicle();
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
                                "Annocements",
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
                                "Notify History",
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
                              MaterialPageRoute(builder: (context) => const NotifyHistory()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
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
                            logout();
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

  popUpForUpdateStudentDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const UpdateStudentDetailsPopup();
      },
    );
  }

  popUpForUpdateProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const UpdateProfilePopup();
      },
    );
  }

  popUpForNotifyPickup({required String uid}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotifyPickup(
          uid: uid,
        );
      },
    );
  }

  popUpForAddupdateVehicle() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddUpdatevehicle();
      },
    );
  }
}
