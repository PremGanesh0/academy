import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/widgets/pickup_accepted.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class NotifyPickup extends StatefulWidget {
  final String uid;
  const NotifyPickup({super.key, required this.uid});

  @override
  NotifyPickupState createState() => NotifyPickupState();
}

class NotifyPickupState extends State<NotifyPickup> {
  TextEditingController messageController = TextEditingController();
  String? selectedOption;
  bool isLoading = false;

  get firebaseFirestore => null; // Track loading state

  @override
  Widget build(BuildContext context) {
    checkParenthaschildornot();
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), // Rounded corners for dialog
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(), // Close the dialog
                ),
              ],
            ),
            const Center(
              child: Text(
                'Notify Pickup',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            RadioListTile<String>(
              title: const Text('In Person'),
              value: 'in_person',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
              activeColor: const Color(0xff47E197), // Change color of selected option
            ),
            RadioListTile<String>(
              title: const Text('To the Car'),
              value: 'to_car',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
              activeColor: const Color(0xff47E197), // Change color of selected option
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20), // Add padding to the right side
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              sendNotification();
                              // checkParenthaschildornot().then((hasChild) async {
                              //     if (hasChild) {
                              //       sendNotification();
                              //     }
                              //   });
                            }, // Disable button when loading or if parent has no child
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff47E197), // Button background color
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Send',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendNotification() {
    setState(() {
      isLoading = true; // Start loading
    });

    // Implement sending selected option
    if (selectedOption != null) {
      // Send selected option
      print('Selected option: $selectedOption');
      // popUpForPickupAccepted();
      sendPushNotificationToAndroidDevice(
        uid: widget.uid,
        title: 'Pickup Notification',
        body: 'Your pickup is $selectedOption.',
      ).then((value) {
        Navigator.pop(context);
      }).catchError((error) {
        // Handle error
      }).whenComplete(() {
        setState(() {
          isLoading = false; // Stop loading
        });
      });
    } else {
      // Show error message or handle empty selection
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void popUpForPickupAccepted() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PickupAccepted();
      },
    );
  }
}
