
import 'package:flutter/material.dart';
import 'package:nurseryapplication_/screens/UI/welcome_screen.dart';
import 'package:nurseryapplication_/services/firebase_auth.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  
  void initState(){
    super.initState();
    _navigatetohome();
    // notification();
  }
_navigatetohome() async{
  await Future.delayed(const Duration(milliseconds: 2500),(){});
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const Welcome()));
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xffFFFBD2),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/background_image.png', // Replace with your background image path
              fit: BoxFit.cover,
            ),
            // Overlaying image
            Center(
              child: Image.asset(
                'assets/nursery_application.png', // Replace with your overlay image path
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
            ),
          ],
        ),
    );
  }
}