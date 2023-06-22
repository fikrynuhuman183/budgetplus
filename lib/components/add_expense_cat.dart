import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budgetplus/main.dart';
import 'custom_alert_dialog.dart';

// class AddExpenseCategory extends StatefulWidget {
//   const AddExpenseCategory({super.key});
//
//   @override
//   State<AddExpenseCategory> createState() => _AddExpenseCategoryState();
// }
//
// class _AddExpenseCategoryState extends State<AddExpenseCategory> {
//   TextEditingController categoryController = TextEditingController();
//
//   Future<void> addCategory({
//     required String category,
//   }) async {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final User? user = auth.currentUser;
//     if (user == null) {
//       Navigator.pushNamedAndRemoveUntil(
//           context, MyApp.loginRoute, (route) => false);
//     }
//     final uid = user?.uid;
//     try {
//       // Add a new subject document to the teacher's subcollection
//       CollectionReference expenseCategoriesRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('expenseCategories');
//
//       DocumentSnapshot snapshot =
//           await expenseCategoriesRef.doc('expenseCategories').get();
//       if (snapshot.exists) {
//         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//         List<String> existingCategories = List<String>.from(data['categories']);
//         List<String> updatedCategories = [...existingCategories, category];
//
//         await expenseCategoriesRef
//             .doc('expenseCategories')
//             .update({'categories': updatedCategories});
//       } else {
//         // If 'categories' document doesn't exist, create a new one with the new categories
//         await expenseCategoriesRef.doc('expenseCategories').set({
//           'categories': [category]
//         });
//       }
//     } catch (e) {
//       // Show an error message if there's an issue with Firestore
//       showDialog(
//           context: context,
//           builder: (context) {
//             print(e);
//             return CustomAlertDialog(
//               title: 'Error',
//               content: 'An error occurred. Please try again later.',
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             );
//           });
//       print('Error adding subject: $e');
//       return;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25), topRight: Radius.circular(25)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Add Category',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 24,
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: categoryController,
//                 decoration: InputDecoration(
//                   labelText: 'Category',
//                   labelStyle: TextStyle(
//                     color: Color(0xFF8F94A3),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.transparent,
//                     ),
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.transparent,
//                     ),
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   fillColor: Colors.white,
//                   filled: true,
//                 ),
//                 style: TextStyle(
//                   color: Color(0xFF6E7491),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextButton(
//                 onPressed: () async {
//                   String category = categoryController.text;
//                   await addCategory(category: category);
//                   Navigator.pop(context);
//                 },
//                 child: Text('Add'),
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(24.0),
//                       side: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class AddExpenseCategory extends StatefulWidget {
  const AddExpenseCategory({Key? key}) : super(key: key);

  @override
  State<AddExpenseCategory> createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategory> {
  TextEditingController categoryController = TextEditingController();
  late String uid;

  Future<void> addCategory({
    required String category,
  }) async {
    try {
      // Add a new subject document to the teacher's subcollection
      CollectionReference expenseCategoriesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenseCategories');

      DocumentSnapshot snapshot =
          await expenseCategoriesRef.doc('expenseCategories').get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<String> existingCategories = List<String>.from(data['categories']);
        List<String> updatedCategories = [...existingCategories, category];

        await expenseCategoriesRef
            .doc('expenseCategories')
            .update({'categories': updatedCategories});
      } else {
        // If 'categories' document doesn't exist, create a new one with the new categories
        await expenseCategoriesRef.doc('expenseCategories').set({
          'categories': [category]
        });
      }
    } catch (e) {
      // Show an error message if there's an issue with Firestore
      showDialog(
          context: context,
          builder: (context) {
            print(e);
            return CustomAlertDialog(
              title: 'Error',
              content: 'An error occurred. Please try again later.',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
      print('Error adding subject: $e');
      return;
    }
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F7FF),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Category',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
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
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                String category = categoryController.text;
                await addCategory(category: category);
                Navigator.pop(context);
              },
              child: Text('Add',
                  style: TextStyle(
                    color: Color(0xFF4A44C6),
                  )),
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
            ),
            SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                height: 200,
                child: CategoryList(uid: uid),
              ),
            ), // Replace with the actual user's UID
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  final String uid;

  const CategoryList({required this.uid});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    getExpenseCategories();
  }

  Future<void> getExpenseCategories() async {
    CollectionReference expenseCategoriesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('expenseCategories');

    DocumentSnapshot snapshot =
        await expenseCategoriesRef.doc('expenseCategories').get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> categoriesData = data['categories'];

      setState(() {
        categories = List<String>.from(categoriesData);
      });
    } else {
      setState(() {
        categories = [];
      });
    }
  }

  Future<void> deleteCategory(String category) async {
    CollectionReference expenseCategoriesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('expenseCategories');

    DocumentSnapshot snapshot =
        await expenseCategoriesRef.doc('expenseCategories').get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String> existingCategories = List<String>.from(data['categories']);
      List<String> updatedCategories =
          existingCategories.where((c) => c != category).toList();

      await expenseCategoriesRef
          .doc('expenseCategories')
          .update({'categories': updatedCategories});

      setState(() {
        categories = updatedCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        String category = categories[index];

        return ListTile(
          title: Text(category),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => deleteCategory(category),
          ),
        );
      },
    );
  }
}
