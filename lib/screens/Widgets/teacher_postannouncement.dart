import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class TeacherPostAnnouncementPopup extends StatefulWidget {
  const TeacherPostAnnouncementPopup({super.key});

  @override
  TeacherPostAnnouncementPopupState createState() => TeacherPostAnnouncementPopupState();
}

class TeacherPostAnnouncementPopupState extends State<TeacherPostAnnouncementPopup> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), // Rounded corners for dialog
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(), // Close the dialog
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0), // Adjust the space as needed
                  child: Text('Post Announcement',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: messageController,
                      maxLines: 15,
                      decoration: InputDecoration(
                        hintText: 'Enter Message Here',
                        fillColor: const Color.fromARGB(255, 182, 180, 180),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width:
                          double.infinity, // Makes the button width equal to the message box width
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle send button click here
                          print('Message sent: ${messageController.text}');
                          postAnnouncement(messageController.text).then((value) {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                              msg: 'Announcement posted successfully!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xFF47E197)), // Button color
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text('Send',
                            style: TextStyle(color: Colors.white)), // Set text color to white
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
