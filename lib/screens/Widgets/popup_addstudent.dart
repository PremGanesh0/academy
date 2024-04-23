import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class AddStudentPopup extends StatefulWidget {
  final String type;

  const AddStudentPopup({super.key, required this.type});

  @override
  AddStudentPopupState createState() => AddStudentPopupState();
}

class AddStudentPopupState extends State<AddStudentPopup> {
  File? _image;
  final picker = ImagePicker();
  String dropdownValue = 'Nursery';

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String ?error;

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
            child: InkWell(
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
            child: Text('Add New Student', textAlign: TextAlign.center),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            InkWell(
              onTap: getImage,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Image.asset('assets/profile.png')
                    : Container(),
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
                    borderSide:
                        const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                  errorText: error,
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
                    borderSide:
                        const BorderSide(color: Color(0xffD2CEAE), width: 1),
                  ),
                  errorText: error,
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
                    border:
                        Border.all(color: const Color(0xff47E197), width: 1),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                         if(nameController.text.isEmpty){
                          error = 'Please enter the name';
                         }else if(idController.text.isEmpty){
                           error = 'Please enter the ID';
                         }else if(_image == null){
                           error = 'Please select the image';
                         }else if(dropdownValue.isEmpty){
                           error = 'Please select the class';
                         }else{
                        createStudent(
                            name: nameController.text,
                            classId: dropdownValue,
                            id: idController.text,
                            imageFile: _image,
                            type: widget.type);
                            Navigator.of(context).pop(); 
                         }
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

  // void openSearchPage(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) =>  SearchPage()), // Navigate to the search page
  //   );
  // }
}
