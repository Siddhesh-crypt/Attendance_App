import 'package:attadance_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _rememberMe = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _prefs = SharedPreferences.getInstance();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields!',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'srv1022.hstgr.io',
        port: 3306,
        db: 'u777017855_DBS_PORT',
        user: 'u777017855_DBS_PORT',
        password: 'aU1#mCd#bL',
      ));

      final results = await conn.query(
        'SELECT * FROM users WHERE username = ? AND password = MD5(?) AND inactive = 0 LIMIT 1',
        [username, password],
      );

      if (results.isNotEmpty) {
        final userData = results.first;
        final userid = userData['id'];
        final usertype = userData['usertype'];
        final centerId = userData['centerId'];
        final accessCenters = userData['accessCenters'];
        final lastLogin = userData['lastlogin'];
        final loginCount = userData['loginCount'];

        // Update last login and login count
        await conn.query(
          'UPDATE users SET lastLogin = ?, loginCount = loginCount + 1 WHERE id = ?',
          [DateTime.now().toString(), userid],
        );

        // Get employee details
        final empResults = await conn.query(
          'SELECT * FROM employee WHERE id = ? AND inactive = 0 LIMIT 1',
          [userid],
        );

        if (empResults.isNotEmpty) {
          final empData = empResults.first;
          final firstName = empData['firstName'];
          final lastName = empData['lastName'];
          final profileUrl = empData['profileUrl'];

          // Set session variables
          // TODO: Implement session management in Flutter
          // For now, just store the values in a map
          final sessionData = {
            'userid': userid,
            'usertype': usertype,
            'centerId': centerId,
            'accessCenters': accessCenters,
            'firstName': firstName,
            'lastName': lastName,
            'profileUrl': profileUrl,
          };

          // If remember me is checked, store the credentials
          if (_rememberMe) {
            final prefs = await _prefs;
            prefs.setString('username', username);
            prefs.setString('password', password);
          }

          // Redirect to homepage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Employee ID is inactive. Contact Head-Office for more details.',
            backgroundColor: Colors.red,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Invalid username or password',
          backgroundColor: Colors.red,
        );
      }

      await conn.close();
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Error connecting to database',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Center(
              child: Image(
                image: AssetImage(
                    'assets/dbskill_logo.png'
                ),
                height: 250,
                width: 250,
              ),
            ),
            Center(
              child: Text(
                'Welcome Back !',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(73, 80, 87, 1)
                ),
              ),
            ),
            SizedBox(height: 5,),
            Center(
              child: Text(
                'Sign in to Continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(116, 120, 141, 1)
                ),
              ),
            ),
            SizedBox(height:15,),
            Padding(
              padding: EdgeInsets.fromLTRB(30,10,0,0),
              child: Text(
                'Username',
                style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(73, 80, 87, 1)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 30, 0),
              child: TextField(
                autofocus: true,
                autocorrect: true,
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.fromLTRB(30,10,0,0),
              child: Text(
                'Password',
                style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(73, 80, 87, 1)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 30, 0),
              child: TextField(
                obscureText: true,
                autofocus: true,
                autocorrect: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,40,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text(
                    'Remember Me',
                    style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color.fromRGBO(73, 80, 87, 1)
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    fixedSize: MaterialStateProperty.all(Size(300, 60))
                ),
                onPressed: _login,
                child: Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}