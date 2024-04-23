
import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/widgets/students_custom_card.dart';

class TeacherDetails extends StatefulWidget {
  const TeacherDetails({super.key});

  @override
  State<TeacherDetails> createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffFFFCDB),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircleAvatar(
                      // Replace the placeholder AssetImage with the actual image asset
                      backgroundImage: AssetImage('assets/profile_image.png',),
                    ),
              ),
              Padding(padding: EdgeInsets.only(top:50,right: 210),
              child: Text("Linked Students",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)
              ),
                Padding(padding: EdgeInsets.only(top: 30),
                child: StudentTaskCard(),
                )
            ],
          ),
        ),
      ),
    );
  }
}