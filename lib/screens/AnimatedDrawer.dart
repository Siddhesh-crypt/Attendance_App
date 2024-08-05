import 'package:attadance_app/screens/attendance_list_page.dart';
import 'package:attadance_app/screens/contact_us.dart';
import 'package:attadance_app/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'attendance_screen.dart';

class AnimatedDrawer extends StatefulWidget {
  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final double maxSlide = 200.0; // Adjust as needed

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    _animationController.isDismissed ? _animationController.forward() : _animationController.reverse();
  }

  void closeDrawer() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        double slide = maxSlide * _animationController.value;
        double scale = 1 - (_animationController.value * 0.3);
        return Stack(
          children: [
            GestureDetector(
              onTap: closeDrawer,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Transform.translate(
              offset: Offset(slide, 0),
              child: Transform.scale(
                scale: scale,
                child: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade700, Colors.lightBlue.shade700, Colors.blueAccent.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 105, // Adjust size as needed
                                width: 105,  // Adjust size as needed
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/dbskill_logo.png'),
                                    fit: BoxFit.fill, // Adjust fit as needed
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Mark Attendance'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AttendanceScreen()),
                          ).then((_) => closeDrawer());
                        },
                      ),
                      ListTile(
                        title: Text('Register Candidate'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          ).then((_) => closeDrawer());
                        },
                      ),
                      ListTile(
                        title: Text('Show Attendance'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AttendanceListPage()),
                          ).then((_) => closeDrawer());
                        },
                      ),
                      ListTile(
                        title: Text('Contact Us'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContactUsPage()),
                          ).then((_) => closeDrawer());
                        },
                      ),
                      // Add more items as needed
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
