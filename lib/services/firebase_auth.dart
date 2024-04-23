import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nurseryapplication_/screens/UI/assistant_profile_screen.dart';
import 'package:nurseryapplication_/screens/UI/parent_profile_screen.dart';
import 'package:nurseryapplication_/screens/UI/teacher_profile_screen.dart';

void addDefaultAdmin() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Create admin user
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: '9999999999@gmail.com', // Replace with admin email
      password: '12345678', // Replace with admin password
    );

    User? user = userCredential.user;

    if (user != null) {
      // Store admin data in Firestore
      await firestore.collection('admins').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        // Add more admin details here if needed
      });

      print('Admin user added successfully.');
    }
  } catch (e) {
    print('Error adding admin user: $e');
  }
}

//write a function to sigin the admin
signInAdmin(
  String email,
  String password,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);

    Fluttertoast.showToast(
      msg: 'Admin signed in successfully',
      backgroundColor: Colors.green,
    );
    return 'Admin signed in successfully';
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error signing in admin: $e', backgroundColor: Colors.red);
    return 'Error signing in admin: $e';
  }
}

signInTeacher(
  String email,
  String password,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    getuserPushNotificationToken('teacher');

    return 'Teacher signed in successfully';
  } catch (e) {
    return 'Error signing in Teacher: $e';
  }
}

signInParent(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  print('email $email');
  print('password $password');
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    getuserPushNotificationToken('parent');

    return 'parent signed in successfully.';
  } catch (e) {
    return 'Error signing in parent : $e';
  }
}

signInAssistant(
  String email,
  String password,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    getuserPushNotificationToken('assistant');

    return 'assistant signed in successfully.';
  } catch (e) {
    return 'Error signing in assistant: $e';
  }
}

registerAndAddUserToFirestore(
    {required String email,
    required String password,
    required String name,
    File? imageFile,
    required String type}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  try {
    // Create user with email and password
    UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      // Upload picture if available
      String imageUrl = "";
      if (imageFile != null) {
        TaskSnapshot uploadTask = await storage.ref('user_images/${user.uid}').putFile(imageFile);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      print('user : ${user.uid}');
      // Store user data in Firestore
      await firestore.collection('parents').doc(user.uid).set({
        'type': type,
        'uid': user.uid,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      });

      return 'Parent Added Successfully';
    } else {
      return 'Failed to create user.';
    }
  } on FirebaseAuthException catch (e) {
    print('Error: ${e.message}');
    // Handle exceptions like email already in use, invalid email, weak password, etc.
  }
}

Future<File?> pickUserImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

//write a function to update parent details and update the password
Future<void> updateParentDetailsAndPassword(String name, String password, File? imageFile) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  User? user = auth.currentUser;
  if (user != null) {
    // Upload picture if available
    String imageUrl = "";
    if (imageFile != null) {
      TaskSnapshot uploadTask = await storage.ref('user_images/${user.uid}').putFile(imageFile);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    // Update user data in Firestore
    await firestore.collection('parents').doc(user.uid).update({
      'name': name,
      'imageUrl': imageUrl,
    });

    // Update user password
    try {
      await user.updatePassword(password);
    } catch (e) {
      // Handle password update error
      print('Failed to update password: $e');
    }
  }
}

//write a function to create a teacher by using three textfeilds and one dropdown box and save data into firestore
createTeacher(
  {required String email,
  required String password,
  required String name,
  required String classId,
  File? imageFile,
  required String type}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  try {
  // Create user with email and password
  UserCredential userCredential =
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  User? user = userCredential.user;

  if (user != null) {
    // Upload picture if available
    String imageUrl = "";
    if (imageFile != null) {
    TaskSnapshot uploadTask = await storage
      .ref('user_images/${user.uid}')
      .putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
    imageUrl = await uploadTask.ref.getDownloadURL();
    print('imageUrl $imageUrl');
    }

    // Add user data to Firestore
    await firestore.collection('teachers').doc(user.uid).set({
    'type': type,
    'uid': user.uid,
    'name': name,
    'email': email,
    'classId': classId,
    'imageUrl': imageUrl,
    });
    print('user.uid ${user.uid}');
    print('teacher created successfully');
    return 'Teacher created successfully';
  } else {
    return 'Failed to create user.';
  }
  } on FirebaseAuthException catch (e) {
  print('Error: ${e.message}');
  return 'Failed to create user: ${e.message}';
  // Handle exceptions like email already in use, invalid email, weak password, etc.
  } on FirebaseException catch (e) {
  print('Error: ${e.message}');
  return 'Failed to create user: ${e.message}';
  // Handle exceptions related to Firebase storage authorization
  } catch (e) {
  print('Error: ${e.toString()}');
  return 'Failed to create user: ${e.toString()}';
  // Handle other exceptions
  }
}

Future<String> createAssistant(
    {required String email,
    required String password,
    required String name,
    File? imageFile,
    required String type}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  try {
    // Create user with email and password
    UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      // Upload picture if available
      String imageUrl = "";
      if (imageFile != null) {
        TaskSnapshot uploadTask = await storage.ref('user_images/${user.uid}').putFile(imageFile);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      // Add user data to Firestore
      await firestore.collection('assistants').doc(user.uid).set({
        'type': type,
        'uid': user.uid,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      });

      return 'User created successfully';
    } else {
      return 'Failed to create user.';
    }
  } on FirebaseAuthException catch (e) {
    print('Error: ${e.message}');
    // Handle exceptions like email already in use, invalid email, weak password, etc.
    return 'Failed to create user: ${e.message}';
  }
}

//write a function to create a teacher by using two textfeilds and one dropdown box and save data into firestore
Future<String> createStudent(
    {required String name,
    required String classId,
    required String id,
    File? imageFile,
    required String type}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  // Upload picture if available
  String imageUrl = "";
  if (imageFile != null) {
    TaskSnapshot uploadTask = await storage.ref('student_images/$name').putFile(imageFile);
    imageUrl = await uploadTask.ref.getDownloadURL();
  }

  // Add student data to Firestore
  DocumentReference studentRef = firestore.collection('students').doc();
  await studentRef.set({
    'type': type,
    'name': name,
    'classId': classId,
    'id': id,
    'imageUrl': imageUrl,
  });

  // Return the UID of the created student
  return studentRef.id;
}

//write a function to add the vehicle detalis to parent
Future<void> addParentVehicleDetails(String parentId, String vehiclename, String vehiclecolor,
    String vehiclenumber, File? image) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  String imageUrl = "";
  if (image != null) {
    TaskSnapshot uploadTask = await storage.ref('user_images/').putFile(image);
    imageUrl = await uploadTask.ref.getDownloadURL();
  }

  await firestore.collection('parents').doc(parentId).update({
    'vehicleName': vehiclename,
    'vehicleColor': vehiclecolor,
    'vehicleNumber': vehiclenumber,
    'vehicalimageurl': imageUrl
  });
}

Future<void> updateParentVehicleDetails(String parentId, String vehiclename, String vehiclecolor,
    String vehiclenumber, File? image) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  String imageUrl = "";
  if (image != null) {
    TaskSnapshot uploadTask = await storage.ref('user_images/').putFile(image);
    imageUrl = await uploadTask.ref.getDownloadURL();
  }

  await firestore.collection('parents').doc(parentId).set({
    'vehicleName': vehiclename,
    'vehicleColor': vehiclecolor,
    'vehicleNumber': vehiclenumber,
    'imageurl': imageUrl
  });
}

Future<void> linkStudentToParent(String parentId, String studentId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if the parent document exists
    final parentDoc = await firestore.collection('parents').doc(parentId).get();
    if (!parentDoc.exists) {
      throw Exception("Parent document with ID $parentId does not exist");
    }

    // Check if the student document exists
    final studentDoc = await firestore.collection('students').doc(studentId).get();
    if (!studentDoc.exists) {
      throw Exception("Student document with ID $studentId does not exist");
    }

    // Update the parent document to link it to the student
    await firestore.collection('parents').doc(parentId).update({
      'studentId': studentId,
    });
  } catch (e) {
    print("Error linking parent to student: $e");
    // Handle error (e.g., show a dialog, log error, etc.)
  }
}

// Future<void>linkParentToStudent(String parentId, String studentId) async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   await firestore.collection('students').doc(studentId).update({
//     'parentId': parentId,
//   });
// }

Future<void> updateStudentDetails(
    String studentId, String name, String classId, String parentId, File? imageFile) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  // Upload picture if available
  String imageUrl = "";
  if (imageFile != null) {
    TaskSnapshot uploadTask = await storage.ref('student_images/$name').putFile(imageFile);
    imageUrl = await uploadTask.ref.getDownloadURL();
  }

  // Update student data in Firestore
  await firestore.collection('students').doc(studentId).update({
    'name': name,
    'classId': classId,
    'parentId': parentId,
    'imageUrl': imageUrl,
  });
}

Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('login Succesfully');
    return userCredential;
  } catch (e) {
    // Handle sign-in errors here
    print("Error signing in: $e");
    return null;
  }
}

// write a function to get the students where patentid
Future<QuerySnapshot> getStudentsByParentId(String parentId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot =
      await firestore.collection('students').where('parentId', isEqualTo: parentId).get();

  return querySnapshot;
}

//write a function to logout
Future<void> logout() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut();
    print('User logged out successfully.');
  } catch (e) {
    print('Error logging out: $e');
  }
}

Future<List<String>> getStudentsByTeacherId(String teacherId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot = await firestore
      .collection('students')
      .where('teacherId', isEqualTo: teacherId)
      .where('classId', isEqualTo: teacherId) // Add this line to filter by classId
      .get();

  List<String> studentIds = [];
  for (var doc in querySnapshot.docs) {
    studentIds.add(doc.id);
  }

  return studentIds;
}

//write a function to search parent name
Future<QuerySnapshot> searchParentByName(String name) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot =
      await firestore.collection('parents').where('name', isEqualTo: name).get();

  return querySnapshot;
}

//write a function to link the parent and students when ever the parentid is selected to particular student the parent id should be add to the students collection
Future<void> linkParentToStudent(String parentId, String studentId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  print(' parent Id $parentId');
  print(' student Id $studentId');
  await firestore.collection('students').doc(studentId).update({'parentId': parentId});
}

Future<void> addStudentWithParentLink({
  required String name,
  required String classId,
  required String id,
  required File? imageFile,
  required String parentId,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String imageUrl = "";
  if (imageFile != null) {
    TaskSnapshot uploadTask = await storage.ref('student_images/$name').putFile(imageFile);
    imageUrl = await uploadTask.ref.getDownloadURL();
  }
  // Step 1: Add the student
  DocumentReference studentRef = await firestore.collection('students').add({
    'name': name,
    'classId': classId,
    'id': id,
    'imageFile': imageUrl,
    'parentId': parentId, // Linking the student to the parent
  });

  // Optionally, you can perform additional updates or logging here
  print("Added student with ID: ${studentRef.id}");

  // Step 2: Update the parent to include this student's ID
  // This step is optional depending on your specific requirements
  DocumentReference parentRef = firestore.collection('parents').doc(parentId);
  await parentRef.update({
    'studentIds': FieldValue.arrayUnion([studentRef.id])
  });

  print("Linked student ${studentRef.id} to parent $parentId");
}

//write a funtion to get the detalis of the student when i tap on the student listtile
Future<DocumentSnapshot> getStudentDetails(String studentId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentSnapshot documentSnapshot = await firestore.collection('students').doc(studentId).get();

  return documentSnapshot;
}

Future<void> getuserPushNotificationToken(String type) async {
  User? firebaseauth;
  firebaseauth = FirebaseAuth.instance.currentUser;
  String pushtoken = '';
  if (Platform.isAndroid) {
    FirebaseMessaging.instance.getToken().then((token) {
      print('This is FCMToken: ' '$token');
      pushtoken = token.toString();
      updatepushNotificationTokentoFirebase(type, pushtoken, 'Android');
    });
  } else if (Platform.isIOS) {
    FirebaseMessaging.instance.getAPNSToken().then((token) {
      print('This is APNSToken: ' '$token');
      pushtoken = token.toString();
      updatepushNotificationTokentoFirebase(type, pushtoken, 'iOS');
    });
  } else {
    return;
  }
}

Future<void> updatepushNotificationTokentoFirebase(
    String type, String token, String Platform) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? firebaseauth;
  firebaseauth = FirebaseAuth.instance.currentUser;
  if (type == 'teacher') {
    await firestore
        .collection('teachers')
        .doc(firebaseauth!.uid)
        .update({'pushtoken': token, 'platform': Platform});
  } else if (type == 'parent') {
    await firestore
        .collection('parents')
        .doc(firebaseauth!.uid)
        .update({'pushtoken': token, 'platform': Platform});
  } else if (type == 'assistant') {
    await firestore
        .collection('assistants')
        .doc(firebaseauth!.uid)
        .update({'pushtoken': token, 'platform': Platform});
  } else {
    return;
  }
}

sendPushNotificationToAndroidDevice({
  required String uid,
  required String title,
  required String body,
}) async {
  try {
    List tokens = await getAssistantTokens();
    print('tokens: $tokens');
    for (var token in tokens) {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAVZUK3No:APA91bHN-XV5qdzMiWZKshxUvZcDXPInFY-II75JHz-95CmsqozDjjXrJPrRKuE6yiN-Nxj1qVzNPlTbAPKZrm58tMhy7wLHBZeizuL75irH8DQH-deFd_UjttK7nlT2nTDN5IM0d93J'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': token,
        }),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Push notification sent successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to send push notification');
      }
    }
    saveNotificationToFirestore(uid, body);
  } catch (error) {
    print('Error sending push notification: ${error.toString()}');
  }
}

void saveNotificationToFirestore(String uid, String message) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.collection('notifications').add({
    'uid': uid,
    'timestamp': FieldValue.serverTimestamp(),
    'message': message,
    'read': false,
  });
}

Future<List<String>> getAssistantTokens() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore.collection('assistants').get();
  List<String> tokens = [];
  for (var doc in querySnapshot.docs) {
    if ((doc.data() as Map?)?.containsKey('pushtoken') == true) {
      tokens.add(doc['pushtoken']);
    }
  }
  print('tokens: $tokens');
  print('length: ${tokens.length}');
  return tokens;
}

//write a function to sigin the teachers parents and assistants by using email and password and navigate to the respective screens by using the type
Future<void> signIn(
    {required String email, required String password, required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = auth.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.collection('teacher').doc(user!.uid).get();

    String type = documentSnapshot.data()!['type'];
    if (type == '0') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TeacherProfile()),
      );
    } else if (type == '2') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ParentProfile()),
      );
    } else if (type == '3') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AssistantProfile()),
      );
    } else {
      return;
    }
    Fluttertoast.showToast(msg: 'Signed in successfully as $type', toastLength: Toast.LENGTH_SHORT);
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error signing in: $e', toastLength: Toast.LENGTH_SHORT);
  }
}

// Function to post announcement
Future<void> postAnnouncement(String message) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? firebaseAuth = FirebaseAuth.instance.currentUser;

  await firestore.collection('announcements').add({
    'message': message,
    'timestamp': FieldValue.serverTimestamp(),
    'uid': firebaseAuth!.uid,
  });
}

Future<String> checkParenthaschildornot() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  QuerySnapshot querySnapshot =
      await firestore.collection('students').where('parentId', isEqualTo: user!.uid).get();
  if (querySnapshot.docs.isNotEmpty) {
    return 'parent has child';
  } else {
    return 'parent has no child';
  }
}
