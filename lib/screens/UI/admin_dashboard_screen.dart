import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nurseryapplication_/screens/UI/dashboard_screen_student.dart';
import 'package:nurseryapplication_/screens/UI/dashboard_screen_teacher.dart';
import 'package:nurseryapplication_/screens/widgets/popup_addassistant.dart';
import 'package:nurseryapplication_/screens/widgets/popup_addparent.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  AdminDashBoardState createState() => AdminDashBoardState();
}

class AdminDashBoardState extends State<AdminDashBoard> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final CollectionReference teachersCollection = FirebaseFirestore.instance.collection('teachers');
  final CollectionReference studentsCollection = FirebaseFirestore.instance.collection('students');
  final CollectionReference parentsCollection = FirebaseFirestore.instance.collection('parents');
  final CollectionReference assistantsCollection =
      FirebaseFirestore.instance.collection('assistants');
  String? name;
  String? classId;
  String? id;
  String? image;
  String? uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AdminDashBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      setState(() {
        teachersCollection.get();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    teachersCollection.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFCDB),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffFFFCDB),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController!,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'Teachers'),
            Tab(text: 'Students'),
            Tab(text: 'Parents'),
            Tab(text: 'Assistants'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController!,
        children: [
          Teacher(
            teacherReference: teachersCollection,
          ),
          Student(studentsCollection: studentsCollection),
          Column(
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
                          style: TextStyle(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          popUpForParent(sectionNumber: _tabController!.index.toString());
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
                future: parentsCollection.get(),
                builder: (context, parentSnapshot) {
                  if (parentSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (parentSnapshot.hasError) {
                    return Text('Error: ${parentSnapshot.error}');
                  } else {
                    final parents = parentSnapshot.data!.docs;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: parents.length,
                        itemBuilder: (context, index) {
                          final parent = parents[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xffD2CEAE)),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Slidable(
                              key: ValueKey(parent.id),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                dismissible: DismissiblePane(onDismissed: () {
                                  // Handle the dismiss action (e.g., delete the item)
                                  parentsCollection.doc(parent.id).delete();
                                }),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      // Perform action like delete
                                      // You can add your functionality here to handle delete
                                      parentsCollection.doc(parent.id).delete();
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
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0), // Apply vertical margin
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(parent['imageUrl']),
                                      ),
                                      title: Text(parent['name']),
                                    ),
                                    const Divider(),
                                    const Text(
                                      'Children:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    FutureBuilder<QuerySnapshot>(
                                      future: studentsCollection
                                          .where('parentId', isEqualTo: parent.id)
                                          .get(),
                                      builder: (context, childSnapshot) {
                                        if (childSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (childSnapshot.hasError) {
                                          return Text('Error: ${childSnapshot.error}');
                                        } else {
                                          final children = childSnapshot.data!.docs;
                                          if (children.isEmpty) {
                                            return const Text(
                                              'Not linked to any students',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            );
                                          }

                                          // If there are linked children, display them
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: children.map((child) {
                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(child['imageUrl']),
                                                ),
                                                title: Text(child['name']),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Standard: ${child['classId']}'),
                                                    Text('ID: ${child['id']}'),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }
                                      },
                                    ),
                                  ],
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
          ),
          Column(children: [
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
                        style: TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        popUpForAssistant(sectionNumber: _tabController!.index.toString());
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
              future: assistantsCollection.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final assistants = snapshot.data!.docs;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: assistants.length,
                      itemBuilder: (context, index) {
                        final assistant = assistants[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffD2CEAE)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Slidable(
                            key: ValueKey(assistant.id),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                                // Handle the dismiss action (e.g., delete the item)
                                assistantsCollection.doc(assistant.id).delete();
                              }),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // Perform action like delete
                                    // You can add your functionality here to handle delete
                                    assistantsCollection.doc(assistant.id).delete();
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
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0), // Apply vertical margin
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(assistant['imageUrl']),
                                ),
                                title: Text(assistant['name']),
                                subtitle: const Text("Assistant"),
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
          ]),
        ],
      ),
    );
  }

  popUpForParent({required String sectionNumber}) {
    print('selected section number is $sectionNumber');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddParentPopup(
          type: sectionNumber,
        );
      },
    );
    setState(() {});
  }

  popUpForAssistant({required String sectionNumber}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAssistantPopup(type: sectionNumber);
      },
    );
    setState(() {});
  }
}
