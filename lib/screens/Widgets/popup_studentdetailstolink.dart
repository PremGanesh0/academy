import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/UI/serach_screen.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class StudentDetailsToLinkParentPopup extends StatefulWidget {
  String uid;
  final String name;
  final String classId;
  final String id;
  final String image;
  
  
  


   StudentDetailsToLinkParentPopup({
    Key? key,
    required this.uid,
    required this.name,
    required this.classId,
    required this.id,
    required this.image, 
    
  }) : super(key: key);

  @override
  State<StudentDetailsToLinkParentPopup> createState() => _StudentDetailsToLinkParentPopupState();
}

class _StudentDetailsToLinkParentPopupState extends State<StudentDetailsToLinkParentPopup> {
  String uid = '';

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
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
                child: Icon(Icons.close, color: Colors.black),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Student Details', textAlign: TextAlign.center),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.image),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text('Name       ${widget.name}',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                      Text('Standard   ${widget.classId}'),
                      Text('Id         ${widget.id}'),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Parent',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
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
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                      child: const Text(
                        "Link Parent",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        linkParent();
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Class Teacher',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profile_image.png'),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    children: [
                      Text("Teacher Name"),
                      Text("Teacher"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void linkParent() {
    print('Student ID is ${widget.uid}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(uid)),
    );
  }
}

// Example of how to use this widget:

// When tapping on the card, call this method to show the AlertDialog:
// void _showStudentDetailsPopup() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StudentDetailsToLinkParentPopup(
//         name: 'John Doe',
//         classId: 'Class 10',
//         id: '123456',
//         image: 'https://example.com/image.jpg',
//       );
//     },
//   );
// }
