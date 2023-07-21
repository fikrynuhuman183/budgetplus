import 'package:flutter/material.dart';
import 'package:budgetplus/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budgetplus/components/custom_alert_dialog.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _nameController;
  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    setState(() {
      showSpinner = true;
    });
    String userName = _userNameController.text;
    String password = _passwordController.text;
    if (password == _confirmPasswordController.text) {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: userName, password: password)
            .then((currentUser) {
          print(currentUser.user?.uid);
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.user?.uid)
              .set({
            'name': _nameController.text,
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.user?.uid)
              .collection('expenseCategories')
              .doc('expenseCategories')
              .set({
            'categories': FieldValue.arrayUnion(['Food'])
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.user?.uid)
              .collection('incomeCategories')
              .doc('incomeCategories')
              .set({
            'categories': FieldValue.arrayUnion(['Monthly Salary'])
          });
        });

        Navigator.pushNamedAndRemoveUntil(
            context, MyApp.mainRoute, (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title: 'Error',
                content: 'The password provided is too weak.',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
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
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title: 'Error',
                content: 'The account already exists for that email.',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        } else if (e.code == 'invalid-email') {
          print('The account already exists for that email.');
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title: 'Error',
                content: 'The email address is invalid. Please try agian',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title: 'Error',
                content: 'Unknown error.',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }
      } catch (e) {
        print(e);
      }
      // Clear the inputs
      _userNameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    } else {
      print('object');
    }
    setState(() {
      showSpinner = false;
    });
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
                'Sign Up',
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                Container(
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    onPressed: _registerUser,
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
