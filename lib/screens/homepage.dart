import 'package:flutter/material.dart';
import 'package:budgetplus/main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: 'tag', child: Image.asset('images/logo.jpg')),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 64.0,
              width: double.infinity,
              child: TextButton(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color(0xFF4A44C6),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide.none,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, MyApp.loginRoute);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 64.0,
              width: double.infinity,
              child: TextButton(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF4A44C6),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide.none,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, MyApp.registrationRoute);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
