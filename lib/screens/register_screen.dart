import 'package:flutter/material.dart';
import 'package:budgetplus/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budgetplus/components/custom_alert_dialog.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    // TODO: implement initState
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }



  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() async{
    String userName=_userNameController.text;
    String password=_passwordController.text;
    if (password == _confirmPasswordController.text) {

      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userName, password: password);

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
        }
      } catch (e) {
        print(e);
      }
      // Clear the inputs
      _userNameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

    }else{
      print('object');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Login Screen',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F7FF),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  labelText: 'Retype-Password',
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
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
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
            ],
          ),
        ),
      ),
    );
  }
}
