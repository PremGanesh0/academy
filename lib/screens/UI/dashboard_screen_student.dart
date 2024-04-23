import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nurseryapplication_/screens/Widgets/popup_addstudent.dart';
import 'package:nurseryapplication_/screens/Widgets/popup_studentdetailstolink.dart';

class Student extends StatefulWidget {
  final CollectionReference studentsCollection;
  const Student({super.key, required this.studentsCollection});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: Center(
            child: Container(
              height: 45,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff47E197), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff2BC67B),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 0),
                    backgroundColor: const Color(0xff47E197),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                  child: const Text(
                    "+ Add",
                    style:
                        TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    popUpForStudent(sectionNumber: '1');
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        FutureBuilder<QuerySnapshot>(
          future: widget.studentsCollection.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final students = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffD2CEAE)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Slidable(
                        key: ValueKey(student.id),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          dismissible: DismissiblePane(onDismissed: () {
                            // Handle the dismiss action (e.g., delete the item)
                            widget.studentsCollection.doc(student.id).delete();
                          }),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Perform action like delete
                                // You can add your functionality here to handle delete
                                widget.studentsCollection.doc(student.id).delete();
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              popUpForStudentDetailsToLinkparents(
                                student['name'],
                                student['classId'],
                                student['id'],
                                student['imageUrl'],
                                student.id,
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(student['imageUrl']),
                            ),
                            title: Text(student['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Standard: ${student['classId']}",
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "ID: ${student['id']}",
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  popUpForStudent({required String sectionNumber}) {
    print('selected section number is $sectionNumber');
    print('inside ');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddStudentPopup(
          type: sectionNumber,
        );
      },
    );
    setState(() {});
  }

  popUpForStudentDetailsToLinkparents(name, classId, id, image, uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StudentDetailsToLinkParentPopup(
          name: name!,
          classId: classId!,
          id: id!,
          image: image!,
          uid: uid!,
        );
      },
    );
    setState(() {});
  }
}
