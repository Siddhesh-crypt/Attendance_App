import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LoginPage.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "Welcome to our app. Let's get started!",
          image: Center(
            child: Image.asset("assets/dbskill_logo.png", height: 300.0),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18.0),
          ),
        ),
        PageViewModel(
          title: "Register Candidates",
          body: "Register candidates easily with their details and photos.",
          image: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Image.asset("assets/register.png", height: 700.0),
              ),
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18.0),
          ),
        ),
        PageViewModel(
          title: "Take Attendance",
          body: "Take attendance with face recognition.",
          image: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Image.asset("assets/mark_attendance.png", height: 700.0),
              ),
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18.0),
          ),
        ),
        PageViewModel(
          title: "Track Attendance",
          body: "Track attendance with face recognition. \n Downloaded File Store in \nFile: '/storage/emulated/0/Android/data/com.example.attadance_app/files/attendance_data.csv'",
          image: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Image.asset("assets/attendance.png", height: 700.0),
              ),
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18.0),
          ),
        ),
      ],
      onDone: () async {
        // Save the flag to indicate that onboarding is done
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstLaunch', false);

        // Navigate to the LoginPage when done
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Loginpage()),
        );
      },
      onSkip: () async {
        // Save the flag to indicate that onboarding is done
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstLaunch', false);

        // Navigate to the LoginPage when skipped
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Loginpage()),
        );
      },
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size.square(10.0),
        activeSize: Size(22.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
