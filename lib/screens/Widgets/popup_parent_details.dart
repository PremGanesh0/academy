import 'package:flutter/material.dart';

class ParentDetailsPopup extends StatefulWidget {
  const ParentDetailsPopup({super.key});

  @override
  State<ParentDetailsPopup> createState() => _ParentDetailsPopupState();
}

class _ParentDetailsPopupState extends State<ParentDetailsPopup> {
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
            child: Text('Parent Details', textAlign: TextAlign.center),
          ),
        ],
      ),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Padding(padding:EdgeInsets.only(top: 10),
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
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Child',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
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
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Car',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      // Replace the placeholder AssetImage with the actual image asset
                      backgroundImage: AssetImage('assets/car.png'),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Car Company"),
                        Text("Car Number : AP 39 XX xxxx"),
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
