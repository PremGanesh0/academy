import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/UI/teacher_details_screen.dart';


class ParentTaskCard extends StatefulWidget {
  const ParentTaskCard({super.key});

 

  @override
  State<ParentTaskCard> createState() => _ParentTaskCardState();
}

class _ParentTaskCardState extends State<ParentTaskCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeacherDetails()),
        );
      },
      child: Card(
        color: const Color(0xffFFFCDB),
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(
                // Replace the placeholder AssetImage with the actual image asset
                backgroundImage: AssetImage('assets/profile_image.png'),
              ),
              title: Text(
                "Tarun",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Parent",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              // onTap: () {
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //       builder: (context) => const TeacherDetails()),
              //   // );
              // },
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
             
          ],
        ),
        
      ),
    );
  }
}
