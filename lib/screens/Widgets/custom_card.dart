import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nurseryapplication_/screens/UI/teacher_details_screen.dart';


class TaskCard extends StatefulWidget {
  const TaskCard({super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
       
      },
      child: Slidable(
        key: UniqueKey(),
        // startActionPane: 
        //      ActionPane(
        //         motion: const ScrollMotion(),
        //         dismissible: DismissiblePane(
        //           onDismissed: () {
                    
        //           },
        //         ),
        //         children: [
        //           SlidableAction(
        //             onPressed: (context) {
                      
        //             },
        //             backgroundColor: const Color(0xFF7BC043),
        //             foregroundColor: Colors.white,
        //             icon:  Icons.check,
        //             borderRadius: const BorderRadius.only(
        //               topLeft: Radius.circular(20),
        //               bottomLeft: Radius.circular(20),
        //             ),
        //           ),
        //         ],
        //       ),
        endActionPane:  ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {

                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: const Color.fromARGB(255, 252, 251, 251),
                    icon: Icons.delete,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ],
              ),
        child: Card(
          color: const Color(0xffFFFCDB),
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
                subtitle: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Teacher",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                  ],
                ),
               
                onTap: () {
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeacherDetails()),
          );
                }, 
              ),
              
            ],
          ),
        ),
      ),
    );
  }
  
 
}