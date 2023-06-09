import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budgetplus/main.dart';
import 'package:budgetplus/components/custom_alert_dialog.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  bool showSpinner = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  Future<String> loginUser() async {
    setState(() {
      showSpinner = true;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _userNameController.text,
              password: _passwordController.text)
          .then((currentUser) {
        _userNameController.clear();
        _passwordController.clear();

        Navigator.pushNamedAndRemoveUntil(
            context, MyApp.mainRoute, (route) => false);
        // Navigator.pushNamed(context, MyApp.teacherDashboardRoute);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Handle user not found error
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              content: 'User Not Found',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
        print('No user found with this email.');
      } else if (e.code == 'wrong-password') {
        // Handle wrong password error
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              content: 'Wrong Password',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
        print('Wrong password provided for this user.');
      } else if (e.code == 'network-request-failed') {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              content: 'Netwrok error, Please check your internet connection',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        // Handle other exceptions
        print('Error: ${e.message}');
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              content: 'Unknown Error, Please contact support',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      // Handle other exceptions
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Error',
            content: 'Unknown Error, Please contact support',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      print('Error: $e');
    }
    setState(() {
      showSpinner = false;
    });
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight +
              16), // Add extra padding (16) to the AppBar height
          child: Padding(
            padding: EdgeInsets.only(top: 16), // Set the desired top padding
            child: AppBar(
              backgroundColor: Color(0xFFF5F7FF),
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF4A44C6),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MyApp.homeRoute, (route) => false);
                },
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFFF5F7FF),
        body: Padding(
          padding: EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username/Email',
                    labelStyle: TextStyle(
                      color: Color(0xFF8F94A3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF6E7491),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color(0xFF8F94A3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF6E7491),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(height: 16.0),
                Container(
                  height: 64.0,
                  width: double.infinity,
                  child: TextButton(
                    child: Text(
                      'Sign in',
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
                    onPressed: loginUser,
                  ),
                ),
                Hero(
                  tag: 'tag',
                  child: Image.asset('images/logo.jpg'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
