
import 'package:attadance_app/screens/attendance_list_page.dart';
import 'package:attadance_app/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'attendance_screen.dart';

class AnimatedDrawer extends StatefulWidget {
  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final double maxSlide = 250.0; // Adjust as needed

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
              onTap: () {
                if (_animationController.isCompleted) toggleDrawer();
              },
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
                            colors: [Colors.purple, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Text(
                          'DB Skills',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      ListTile(
                        title: Text('Mark Attendence'),
                        onTap: () {
                          // Implement navigation or action
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AttendanceScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Register Candidate'),
                        onTap: () {
                          // Implement navigation or action
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Show Attendence'),
                        onTap: () {
                          // Implement navigation or action
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AttendanceListPage()),
                          );
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
