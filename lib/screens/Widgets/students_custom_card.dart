import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/widgets/popup_student_details.dart';


class StudentTaskCard extends StatefulWidget {
  const StudentTaskCard({super.key});

  @override
  State<StudentTaskCard> createState() => _StudentTaskCardState();
}

class _StudentTaskCardState extends State<StudentTaskCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // popUpForStudentDetails ();
          // popUpForStudentDetailsToLinkparents (
          //   "Tarun",
          //   "Standard 1st",
          //   "#234567",
          //   'assets/profile_image.png'
          // );
        },
        child: Card(
        
          color: const Color(0xffFFFCDB),
          shadowColor: const Color(0xffD2CEAE),
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  // Replace the placeholder AssetImage with the actual image asset
                  backgroundImage: AssetImage('assets/profile_image.png'),
                ),
                title: const Text(
                  "Tarun",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Flexible(
                  child: Text(
                    "Standard        1st",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                trailing: const Flexible(
                  child: Text(
                    "ID       #234567",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                onTap: () {
                  // popUpForStudentDetails ( );
                  // popUpForStudentDetailsToLinkparents (
                  //   "Tarun",
                  //   "Standard 1st",
                  //   "#234567",
                  //   'assets/profile_image.png'
                  // );
                },
              ),
            ],
          ),
        ));
  }
  popUpForStudentDetails () {
    showDialog(
  context: context,
  builder: (BuildContext context) {
    return const StudentDetailsPopup();
  },
);
  } 


//     popUpForStudentDetailsToLinkparents (
//       nameController,
//     dropdownValue,
//     idController,
//     image
//     ) {
//     showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return  const StudentDetailsToLinkParentPopup();
//   },
// );
//   }
// }
}