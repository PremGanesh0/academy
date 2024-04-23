import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class AddTeacherPopup extends StatefulWidget {
  final String type;
  const AddTeacherPopup({super.key, required this.type});

  @override
  AddTeacherPopupState createState() => AddTeacherPopupState();
}

class AddTeacherPopupState extends State<AddTeacherPopup> {
  File? _image;
  final picker = ImagePicker();
  String dropdownValue = 'Nursery';
  bool isloading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  String? error;

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
            child: Text('Add New Teacher ', textAlign: TextAlign.center),
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
              padding: const EdgeInsets.only(top: 10),
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
                  errorText: error,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, right: 120),
              child: Text(
                'Mobile Number',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: phonenumberController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Mobile Number',
                  fillColor: const Color(0xffF4F4F4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                  counterText: '',
                  errorText: error,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, right: 120),
              child: Text(
                'Assign To The Class',
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
                        items: <String>['Nursery', 'L.K.G', 'U.K.G', '1st standard']
                            .map<DropdownMenuItem<String>>((String value) {
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
                'Password',
                style: TextStyle(color: Color(0xffFF8762)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: passwordController,
                maxLength: 12,
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: const Color(0xffF4F4F4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                  counterText: '',
                  errorText: error,
                ),
                onChanged: (value) {
                  setState(() {
                    error = null;
                  });
                },
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
                      onPressed: () {
                        setState(() {
                          isloading = true;
                        });
                        createTeacher(
                                email: "${phonenumberController.text}@gmail.com",
                                password: passwordController.text,
                                name: nameController.text,
                                classId: dropdownValue,
                                imageFile: _image,
                                type: widget.type)
                            .then((value) {
                          if (value == 'Teacher created successfully') {
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              isloading = false;
                            });
                            Fluttertoast.showToast(
                                msg: value,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        });
                      },
                      child: isloading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Add",
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
