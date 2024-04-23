import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nurseryapplication_/screens/UI/teacher_profile_screen.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({super.key});

  @override
  State<TeacherLogin> createState() => TeacherLoginState();
}

class TeacherLoginState extends State<TeacherLogin> {
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  bool islogin = false;
  bool isvisible = true;
  String? error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xffFFFBD2),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/login_as_teacher.png',
                ),
                const SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: phonenumber,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      fillColor: const Color(0xffFFFBD2),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 2),
                      ),
                      counterText: '',
                      errorText: error,
                    ),
                    onChanged: (value) {
                      setState(() {
                        error = null;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: password,
                    obscureText: isvisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      fillColor: const Color(0xffFFFBD2),
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isvisible = !isvisible;
                          });
                        },
                        icon: isvisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xffD2CEAE), width: 2),
                      ),
                      errorText: error,
                    ),
                    onChanged: (value) {
                      setState(() {
                        error = null;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                islogin
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
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
                                child: islogin
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  if (phonenumber.text.isEmpty) {
                                    setState(() {
                                      error = 'Please enter the phone number';
                                    });
                                  } else if (!RegExp(r'^(?:\+91|91)?[6789]\d{9}$')
                                      .hasMatch(phonenumber.text)) {
                                    setState(() {
                                      error = 'Please enter a valid phone number';
                                    });
                                  } else if (password.text.isEmpty) {
                                    setState(() {
                                      error = 'Please enter the password';
                                    });
                                  } else {
                                    setState(() {
                                      islogin = true;
                                      error = null;
                                    });
                                    signInTeacher("${phonenumber.text}@gmail.com", password.text)
                                        .then((value) {
                                      if (value == 'Teacher signed in successfully') {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const TeacherProfile()),
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: value,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                      setState(() {
                                        islogin = false;
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
