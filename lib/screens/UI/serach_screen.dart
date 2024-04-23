import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  String uid;
  SearchPage(this.uid, {super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  final CollectionReference parentsCollection = FirebaseFirestore.instance.collection('parents');

  Future<QuerySnapshot>? searchResultsFuture;

  void handleSearch(String query) {
    if (query.isNotEmpty) {
      Future<QuerySnapshot> parents = searchParentByName(query);
      setState(() {
        searchResultsFuture = parents;
      });
    } else {
      setState(() {
        searchResultsFuture = null; // Reset the search results
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFBD2),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: handleSearch,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: searchResultsListView(),
          ),
        ],
      ),
    );
  }

  Widget searchResultsListView() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture ?? parentsCollection.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Center(
              child: CircularProgressIndicator(
              ),
            ),
          ); 
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Text('No results found');
        } else {
          final parents = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
              itemCount: parents.length,
              itemBuilder: (context, index) {
                final parent = parents[index];
                var link = parent['uid'];
                return ListTile(
                  onTap: () {
                    checkAndLinkParentToStudent(link, widget.uid);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(parent['imageUrl']),
                  ),
                  title: Text(parent['name']),
                );
              },
            ),
          );
        }
      },
    );
  }

 Future<QuerySnapshot> searchParentByName(String name) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return await firestore
      .collection('parents')
      .where('name', isGreaterThanOrEqualTo: name)
      .where('name', isLessThanOrEqualTo: name + '\uf8ff')
      .get();
}


  void checkAndLinkParentToStudent(String parentUID, String studentUID) {
    // Check if the parent is already linked to a student
    FirebaseFirestore.instance
        .collection('students')
        .where('parentId', isEqualTo: parentUID)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Parent is already linked to a student
        Fluttertoast.showToast(
          msg: 'This parent is already linked to a student',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey, 
          textColor: Colors.white,
        );
      } else {
        // Parent is not linked to any student, so link them
        linkParentToStudent(parentUID, studentUID);
        linkStudentToParent(parentUID, studentUID);
        // Show success toast message
        Fluttertoast.showToast(
          msg: 'Parent linked to student successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    });
  }
}
