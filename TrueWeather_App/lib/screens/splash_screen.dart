import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a 10-second delay before navigating to the next screen
    Future.delayed(Duration(seconds: 10), () {
      // Navigate to the next screen or perform any other action after the delay
      // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your image here
            Image.network(
              '/assets/images/splash.jpg',
              width: 200, // adjust the width as needed
              height: 200, // adjust the height as needed
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Weatherman's Daily Insight",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
