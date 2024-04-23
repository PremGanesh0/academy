import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nurseryapplication_/screens/Widgets/popup_addteacher.dart';

class Teacher extends StatefulWidget {
  final CollectionReference teacherReference;
  const Teacher({super.key, required this.teacherReference});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  @override
  void initState() {
    super.initState();
    widget.teacherReference.get();
    print('initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    widget.teacherReference.get();
    print('didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant Teacher oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.teacherReference != widget.teacherReference) {
      setState(() {
        widget.teacherReference.get();
      });
    }
    print('didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    print('build');
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
                      offset: Offset(0, 2),
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
                    popUpForTeacher(sectionNumber: "0");
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
          future: widget.teacherReference.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final teachers = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffD2CEAE)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Slidable(
                        key: ValueKey(teacher.id),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          dismissible: DismissiblePane(onDismissed: () {
                            widget.teacherReference.doc(teacher.id).delete();
                          }),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Perform action like delete
                                // You can add your functionality here to handle delete
                                widget.teacherReference.doc(teacher.id).delete();
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
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(teacher.get('imageUrl')),
                            ),
                            title: Text(teacher.get('name')),
                            subtitle: Text(teacher.get('classId')),
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

  popUpForTeacher({required String sectionNumber}) {
    print('selected section number is $sectionNumber');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTeacherPopup(type: sectionNumber);
      },
    );
  }

 
}
