import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/widgets/popup_parent_details.dart';
import 'package:nurseryapplication_/screens/widgets/students_custom_card.dart';

class ParentStudentCard extends StatefulWidget {
  const ParentStudentCard({super.key});

 

  @override
  State<ParentStudentCard> createState() => _ParentStudentCardState();
}

class _ParentStudentCardState extends State<ParentStudentCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        popUpForParentDetails ();
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
                      "Venkata Ramesh",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
             const StudentTaskCard()
          ],
        ),
        
      ),
    );
  }
   popUpForParentDetails () {
    showDialog(
  context: context,
  builder: (BuildContext context) {
    return const ParentDetailsPopup();
  },
);
  } 
}
