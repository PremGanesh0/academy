import 'package:flutter/material.dart';


class StudentDetailsPopup extends StatefulWidget {
  const StudentDetailsPopup({super.key});

  @override
  State<StudentDetailsPopup> createState() => _StudentDetailsPopupState();
}

class _StudentDetailsPopupState extends State<StudentDetailsPopup> {
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
            const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      // Replace the placeholder AssetImage with the actual image asset
                      backgroundImage: AssetImage('assets/profile_image.png'),
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text("Student Name"),
                        Text('Standard 1st'),
                        Text('ID  #12345')
                      ],
                    )
                  ],
                )),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Parent',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(padding:EdgeInsets.only(top: 10),
            child: Row(
              children: [
                CircleAvatar(
                      // Replace the placeholder AssetImage with the actual image asset
                      backgroundImage: AssetImage('assets/profile_image.png'),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text('Parent Name'),
                        Text('Mobile: +91xxxxxxxxxx'),
                      ],
                    )
              ],
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
                    fontSize: 14),
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      // Replace the placeholder AssetImage with the actual image asset
                      backgroundImage: AssetImage('assets/profile_image.png'),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Teacher Name"),
                        Text("Teacher"),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
