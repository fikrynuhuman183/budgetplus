import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/userpage.dart';
import 'screens/incomepage.dart';
import 'screens/statisticspage.dart';
import 'screens/expensepage.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String homeRoute = '/';
  static const String mainRoute = '/mainPage';
  static const String loginRoute = '/student-login';
  static const String registrationRoute = '/registration';
  static const String teacherDashboardRoute = '/teacher-dashboard';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:homeRoute,
      routes: {
        homeRoute: (context) => HomePage(),
        mainRoute: (context) => MainPage(),
        registrationRoute: (context) => RegisterPage(),
        loginRoute: (context) => LoginPage(),

      },
    );
  }
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 64.0,
              width: double.infinity,
              child: TextButton(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF4A44C6),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
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
                  'Register',
                  style: TextStyle(
                    color: Color(0xFF4A44C6),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
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








