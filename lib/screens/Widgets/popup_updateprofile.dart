import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class UpdateProfilePopup extends StatefulWidget {
  const UpdateProfilePopup({super.key});

  @override
  UpdateProfilePopupState createState() => UpdateProfilePopupState();
}

class UpdateProfilePopupState extends State<UpdateProfilePopup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  File? image;
  bool passwordsMatch = false;
  bool isvisile = true;
  bool isnewvisile = true;
  bool isnewsvisile = true;
  User? firebaseauth;
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
      nameController.text = documentSnapshot['name'];
      phonenumberController.text = documentSnapshot['email'].split('@')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        children: <Widget>[
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close, color: Colors.grey),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Update Profile',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 30, right: 180),
              child: Text(
                'Name',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter the Name',
                  fillColor: const Color(0xffF4F4F4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, right: 180),
              child: Text(
                'Mobile',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: phonenumberController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Enter the mobile number',
                  fillColor: const Color(0xffF4F4F4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, right: 100),
              child: Text(
                'Change Password',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, right: 100),
              child: Text(
                'Old Password',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: oldpasswordController,
                obscureText: isvisile,
                decoration: InputDecoration(
                  hintText: 'Enter the Old password',
                  fillColor: const Color(0xffF4F4F4),
                  filled: true,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isvisile = !isvisile;
                        });
                      },
                      icon: isvisile
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, right: 100),
              child: Text(
                'New Password',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: newpasswordController,
                obscureText: isnewvisile,
                decoration: InputDecoration(
                  hintText: 'Enter the New password',
                  fillColor: const Color(0xffF4F4F4),
                  filled: true,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isnewvisile = !isnewvisile;
                        });
                      },
                      icon: isvisile
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, right: 100),
              child: Text(
                'Confirm Password',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: confirmpasswordController,
                obscureText: isnewsvisile,
                decoration: InputDecoration(
                  hintText: 'Enter Confirm password',
                  fillColor: const Color(0xffF4F4F4),
                  filled: true,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isnewsvisile = !isnewsvisile;
                        });
                      },
                      icon: isvisile
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty && newpasswordController.text.isEmpty) {
                      passwordsMatch = true;
                    } else {
                      passwordsMatch = newpasswordController.text == value;
                    }
                  });
                },
              ),
            ),
            confirmpasswordController.text.isEmpty
                ? const SizedBox()
                : passwordsMatch
                    ? const Text('  Passwords match',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20.0))
                    : const Text('Password not match',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0)),
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
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
                        "Update",
                        style: TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        updateParentDetailsAndPassword(
                                nameController.text, confirmpasswordController.text, image)
                            .then((value) {
                          setState(() {
                            nameController.text = nameController.text;
                          });
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // actions: <Widget>[
    //   Align(
    //     alignment: Alignment.topRight,
    //     child: IconButton
    //       icon: const Icon(Icons.close),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //   ),
    // ],
  }
}
