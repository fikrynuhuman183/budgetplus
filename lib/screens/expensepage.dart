import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budgetplus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budgetplus/components/custom_alert_dialog.dart';
import 'package:budgetplus/components/add_expense_cat.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late String _selectedExpenseType;
  bool showSpinner = false;
  late List<String> categoriesList = [];

  late String uid;

  Future<void> getExpenseCategories() async {
    setState(() {
      showSpinner = true;
    });
    CollectionReference expenseCategoriesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenseCategories');

    DocumentSnapshot snapshot =
        await expenseCategoriesRef.doc('expenseCategories').get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> categories = data['categories'];

      categoriesList = List<String>.from(categories);
    } else {
      categoriesList =
          []; // Reset the list if 'categories' document doesn't exist
    }
    if (categoriesList.isEmpty) {
      categoriesList = ['Please Add a Category'];
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, MyApp.loginRoute, (route) => false);
    } else {
      uid = user!.uid;
    }

    getExpenseCategories();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitExpense() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, MyApp.loginRoute, (route) => false);
    }
    final uid = user?.uid;

    String amount = _amountController.text;
    String category = _selectedExpenseType;
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

    // Create a map of the expense data
    Map<String, dynamic> expenseData = {
      'amount': amount,
      'category': category,
      'note': note,
      'date': selectedDate,
    };

    // Add the expense data to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .add(expenseData)
        .then((value) {
      // Show a success message
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Success',
            content: 'Expense added successfully.',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );

      // Clear the input fields
      _amountController.clear();
      _selectedExpenseType = categoriesList[0];
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
  Widget build(BuildContext context) {
    _selectedExpenseType = categoriesList[0];
    getExpenseCategories();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Expenses',
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
                value: _selectedExpenseType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedExpenseType = newValue!;
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
                  labelText: 'Expense Type',
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
                    return 'Please select an expense type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (Rs)',
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
              SizedBox(height: 30.0),
              Container(
                height: 64.0,
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    'Add Expense',
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
                  onPressed: _submitExpense,
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 64.0,
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    'Edit Expense Categories',
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
                    Navigator.pushNamed(context, MyApp.addExpCat);
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
