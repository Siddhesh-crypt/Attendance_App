import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final Map<String, dynamic> sessionData;

  const Homepage(this.sessionData, {super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Welcome, ${widget.sessionData['firstName']}!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'IBM Plex Sans'
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            /*CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.sessionData['profileUrl']),
            ),*/
            SizedBox(height: 20),
            Text(
              'User ID: ${widget.sessionData['userid']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'User Type: ${widget.sessionData['usertype']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Center ID: ${widget.sessionData['centerId']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Access Centers: ${widget.sessionData['accessCenters']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}