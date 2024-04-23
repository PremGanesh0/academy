import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddUpdatevehicle extends StatefulWidget {
  const AddUpdatevehicle({super.key});

  @override
  AddUpdatevehicleState createState() => AddUpdatevehicleState();
}

class AddUpdatevehicleState extends State<AddUpdatevehicle> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController carnameController = TextEditingController();
  TextEditingController carcolorController = TextEditingController();
  TextEditingController registrationNoController = TextEditingController();
  String? parentid;
  String? carimage;
  bool isLoading = false; // Track loading state

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  User? firebaseauth;
  @override
  void initState() {
    super.initState();
    firebaseauth = FirebaseAuth.instance.currentUser;
    getUserData();
  }

  Future<void> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('parents').doc(firebaseauth!.uid).get();
    setState(() {
      parentid = documentSnapshot.data()!['uid'];
      carnameController.text = documentSnapshot['vehicleName'] ?? '';
      carcolorController.text = documentSnapshot['vehicleColor'] ?? '';
      registrationNoController.text = documentSnapshot['vehicleNumber'] ?? '';
      carimage = documentSnapshot['vehicalimageurl'] ?? '';
    });
  }

  Future<void> addParentVehicleDetails(
      String parentID, String carName, String carColor, String registrationNo, File? image) async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    // Perform the add/update operation
    // Replace this with your actual implementation
    await Future.delayed(const Duration(seconds: 2));

    // Hide loading indicator
    setState(() {
      isLoading = false;
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
              'Add/Update Vehicle',
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
                backgroundImage: NetworkImage(carimage ?? ''),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, right: 180),
              child: Text(
                'Car Name',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: carnameController,
                decoration: InputDecoration(
                  hintText: 'Enter the Car Name',
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
              padding: EdgeInsets.only(top: 30, right: 180),
              child: Text(
                'Car Color',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: carcolorController,
                decoration: InputDecoration(
                  hintText: 'Enter the Car Color',
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
              padding: EdgeInsets.only(top: 30, right: 180),
              child: Text(
                'Registration Number',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: registrationNoController,
                decoration: InputDecoration(
                  hintText: 'Enter the Registration Number',
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
                      onPressed: isLoading
                          ? null // Disable button when loading
                          : () {
                              addParentVehicleDetails(
                                parentid!,
                                carnameController.text,
                                carcolorController.text,
                                registrationNoController.text,
                                _image,
                              ).then((value) {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: 'Vehicle Updated Successfully',
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white);
                              });
                            },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Update",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
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
}
