import 'package:flutter/material.dart';

class PickupAccepted extends StatefulWidget {
  const PickupAccepted({super.key});



  @override
  PickupAcceptedState createState() => PickupAcceptedState();
}

class PickupAcceptedState extends State<PickupAccepted> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Rounded corners for dialog
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              'Pickup Accepted',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60, // 100 / 2 = 50
                backgroundImage: AssetImage('assets/profile_image.png'),
                backgroundColor: Colors.transparent,
                // Adjust width and height of the CircleAvatar
                // width: 100,
                // height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Fathima',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15),
              Text(
                '+965 6958 875',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                // Add your student information widgets here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
