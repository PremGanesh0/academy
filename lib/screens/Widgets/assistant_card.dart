import 'package:flutter/material.dart';



class AssistantTaskCard extends StatefulWidget {
  const AssistantTaskCard({super.key});

  @override
  State<AssistantTaskCard> createState() => _AssistantTaskCardState();
}

class _AssistantTaskCardState extends State<AssistantTaskCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
       
      },
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
             
              onTap: () { }, 
            ),
            
          ],
        ),
      ),
    );
  }
  
 
}