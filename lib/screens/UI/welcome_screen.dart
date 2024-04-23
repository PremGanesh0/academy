import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/UI/admin_login_screen.dart';
import 'package:nurseryapplication_/screens/UI/assistant_login_screen.dart';
import 'package:nurseryapplication_/screens/UI/parent_login_screen.dart';
import 'package:nurseryapplication_/screens/UI/teacher_login_screen.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFBD2),
      body: Center(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background_image.png'), // Adjust path to your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content overlay
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/welcome_login_as.png', // Adjust path to your overlay image
                  // height: , // Adjust height as needed
                ),
                const SizedBox(height: 20), // Spacer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
                      child: Center(
                        child: Container(
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff66D0D7), width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff45A6AC),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(MediaQuery.of(context).size.width, 0),
                                backgroundColor: const Color(0xff66D0D7),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                              ),
                              child: const Text(
                                "Parent",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ParentLogin()),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: Center(
                        child: Container(
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffFFA8A8), width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color(0xffE57C7C),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ]),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(MediaQuery.of(context).size.width, 0),
                                backgroundColor: const Color(0xffFFA8A8),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                              ),
                              child: const Text(
                                "Assistant",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AssistantLogin()),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Spacer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: Center(
                        child: Container(
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffAF8AEC), width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color(0xff8F66D2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ]),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(MediaQuery.of(context).size.width, 0),
                                backgroundColor: const Color(0xffAF8AEC),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                              ),
                              child: const Text(
                                "Teacher",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TeacherLogin()),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: Center(
                        child: Container(
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffE1B674), width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color(0xffC39A5A),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ]),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(MediaQuery.of(context).size.width, 0),
                                backgroundColor: const Color(0xffE1B674),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                              ),
                              child: const Text(
                                "Admin",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AdminLogin()),
                                );
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
          ],
        ),
      ),
    );
  }
}
