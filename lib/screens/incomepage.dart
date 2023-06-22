import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budgetplus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budgetplus/components/custom_alert_dialog.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late String _selectedIncomeType;
  bool showSpinner = false;
  late List<String> categoriesList = ['Please Add a Cateogry'];
  late String uid;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> getIncomeCategories() async {
    setState(() {
      showSpinner = true;
    });
    CollectionReference incomeCategoriesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('incomeCategories');

    DocumentSnapshot snapshot =
        await incomeCategoriesRef.doc('incomeCategories').get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> categories = data['categories'];

      categoriesList = List<String>.from(categories);
    }
    if (categoriesList.isEmpty) {
      categoriesList = ['Please Add a Category'];
    }
    setState(() {
      showSpinner = false;
    });
  }

  void _submitIncome() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, MyApp.loginRoute, (route) => false);
    }
    final uid = user?.uid;

    String amount = _amountController.text;
    String category = _selectedIncomeType;
    String note = _noteController.text;
    DateTime selectedDate = _selectedDate;

    // Validate the input
    if (amount.isEmpty || category.isEmpty || selectedDate == null) {
      // Show an error message if any field is empty
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Error',
            content: 'Please complete all fields.',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    // Create a map of the income data
    Map<String, dynamic> incomeData = {
      'amount': amount,
      'category': category,
      'note': note,
      'date': selectedDate,
    };

    // Add the income data to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('income')
        .add(incomeData)
        .then((value) {
      // Show a success message
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Success',
            content: 'Income added successfully.',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );

      // Clear the input fields
      _amountController.clear();
      _selectedIncomeType = categoriesList[0];
      _noteController.clear();
      _selectedDate = DateTime.now();
    }).catchError((error) {
      // Show an error message if there's an issue with Firestore
      showDialog(
        context: context,
        builder: (context) {
          print(error);
          return CustomAlertDialog(
            title: 'Error',
            content: 'An error occurred. Please try again later.',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    });
  }

  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, MyApp.loginRoute, (route) => false);
    } else {
      uid = user!.uid;
    }

    getIncomeCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedIncomeType = categoriesList[0];
    getIncomeCategories();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Income',
          style: TextStyle(
            color: Colors.grey,
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
              DropdownButtonFormField<String>(
                value: _selectedIncomeType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIncomeType = newValue!;
                  });
                },
                items: categoriesList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                decoration: InputDecoration(
                  labelText: 'Income Type',
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
                validator: (value) {
                  if (value == null) {
                    return 'Please select an income type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
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
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note',
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
              InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Color(0xFF6E7491),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(
                          color: Color(0xFF6E7491),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 64.0,
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    'Add income',
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
                  onPressed: _submitIncome,
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 64.0,
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    'Edit Income Categories',
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
                    // showModalBottomSheet(
                    //     context: context,
                    //     isScrollControlled: true,
                    //     useSafeArea: true,
                    //     builder: (BuildContext context) {
                    //       return AddExpenseCategory();
                    //     });
                    Navigator.pushNamed(context, MyApp.addIncCat);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
