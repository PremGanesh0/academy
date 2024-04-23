import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nurseryapplication_/screens/UI/admin_dashboard_screen.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => AdminLoginState();
}

class AdminLoginState extends State<AdminLogin> {
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  String? error;
  bool isvisible = true;
  bool islogin = false;

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
                  'assets/login_as_admin.png',
                ),
                const SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                      controller: phonenumber,
                      keyboardType: TextInputType.phone,
                      maxLength: 10, // Set the input type to phone number
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
                      }),
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
                              : const Icon(Icons.visibility)),
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
                          onPressed: islogin
                              ? null
                              : () {
                                  if (phonenumber.text.isEmpty) {
                                    setState(() {
                                      error = 'Please enter the phone number';
                                    });
                                    return;
                                  } else if (!RegExp(
                                          r'^(?:\+965|0)?(?:50|51|52|55|56|58|2|3|4|6|7|9)\d{7}$')
                                      .hasMatch(phonenumber.text)) {
                                    setState(() {
                                      error = 'Please enter a valid phone number';
                                    });
                                    return;
                                  } else if (password.text.isEmpty) {
                                    setState(() {
                                      error = 'Please enter the password';
                                    });
                                    return;
                                  }

                                  setState(() {
                                    islogin = true;
                                  });

                                  phonenumber.text.trim();
                                  password.text.trim();

                                  signInAdmin(
                                    "${phonenumber.text}@gmail.com",
                                    password.text,
                                  ).then((value) {
                                    setState(() {
                                      islogin = false;
                                    });
                                    if (value == 'Admin signed in successfully') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const AdminDashBoard()),
                                      );
                                    } else {
                                      Fluttertoast.showToast(msg: value);
                                    }
                                  });
                                },
                          child: islogin
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
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
