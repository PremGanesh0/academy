import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateStudentDetailsPopup extends StatefulWidget {
  const UpdateStudentDetailsPopup({Key? key}) : super(key: key);

  @override
  UpdateStudentDetailsPopupState createState() => UpdateStudentDetailsPopupState();
}

class UpdateStudentDetailsPopupState extends State<UpdateStudentDetailsPopup> {
  File? _image;
  final picker = ImagePicker();
  String dropdownValue = 'Nursery';
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  late User currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });
      fetchStudentData(currentUser.uid);
    }
  }

  Future<void> fetchStudentData(String parentId) async {
    try {
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(parentId)
          .get();

      if (parentSnapshot.exists) {
        String? studentID = parentSnapshot['studentId'];
        if (studentID != null) {
          DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
              .collection('students')
              .doc(studentID)
              .get();

          if (studentSnapshot.exists) {
            setState(() {
              nameController.text = studentSnapshot['name'];
              idController.text = studentSnapshot['id'];
              dropdownValue = studentSnapshot['classId'];
            });
          } else {
            print('Student document does not exist');
          }
        } else {
          print('Student ID is null');
        }
      } else {
        print('Parent document does not exist');
      }
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
              'Update Student Profile',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              onTap: getImage,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Image.asset('assets/profile.png') : Container(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, right: 180),
              child: Text(
                'Name',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,),
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
              padding: EdgeInsets.only(top: 30, right: 120),
              child: Text(
                'Standard',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>[
                          'Nursery',
                          'L.K.G',
                          'U.K.G',
                          '1st standard'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, right: 180),
              child: Text(
                'ID',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: 'Give ID Number',
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
            Padding(
              padding: const EdgeInsets.only(top: 30.0,),
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
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        // Call the method to update student details
                        updateStudentDetails();
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
  }

  Future<void> updateStudentDetails() async {
    try {
      String parentId = currentUser.uid;
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(parentId)
          .get();

      if (parentSnapshot.exists) {
        String? studentID = parentSnapshot['studentId'];
        if (studentID != null) {
          await FirebaseFirestore.instance.collection('students').doc(studentID).update({
            'name': nameController.text,
            'id': idController.text,
            'classId': dropdownValue,
            // Update other fields as needed
          });
          Navigator.of(context).pop(); // Close the dialog
        } else {
          print('Student ID is null');
        }
      } else {
        print('Parent document does not exist');
      }
    } catch (e) {
      print('Error updating student details: $e');
    }
  }
}
