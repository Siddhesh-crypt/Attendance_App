import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _rememberMe = false;

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
                onPressed: () {
                  // Add your login logic here
                },
                child: Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}