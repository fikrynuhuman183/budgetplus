import 'package:flutter/material.dart';
import 'package:budgetplus/components/expense_statistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budgetplus/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late String uid;
  String selectedTab = 'expenses';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FF),
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 40.0,
                child: TextButton(
                  child: Text(
                    'Expenses',
                    style: TextStyle(
                      color: Color(0xFF4A44C6),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedTab = 'expenses';
                    });
                  },
                ),
              ),
              Container(
                height: 40.0,
                child: TextButton(
                  child: Text(
                    'Income',
                    style: TextStyle(
                      color: Color(0xFF4A44C6),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedTab = 'income';
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RecordsListView(
              uid: uid,
              collectionPath: selectedTab,
            ),
          ],
        ),
      ),
    );
  }
}

Future<double> fetchExpensesForMonth(
    DateTime month, String uid, String collectionPath) async {
  final previousMonth = DateTime(month.year, month.month - 1);
  final startOfMonth = DateTime(previousMonth.year, previousMonth.month, 1);
  final endOfMonth =
      DateTime(previousMonth.year, previousMonth.month + 1, 0, 23, 59, 59);

  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection(collectionPath)
      .where('date', isGreaterThanOrEqualTo: startOfMonth)
      .where('date', isLessThanOrEqualTo: endOfMonth)
      .get();

  final List<Expense> expenses = snapshot.docs.map((doc) {
    final data = doc.data() as Map;
    return Expense(
      amount: data['amount'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'],
    );
  }).toList();

  double categoryTotals = 0;
  for (final expense in expenses) {
    categoryTotals = categoryTotals! + double.parse(expense.amount);
  }
  return categoryTotals;
}

class RecordsListView extends StatelessWidget {
  final String uid;
  final String collectionPath;

  const RecordsListView({
    required this.uid,
    required this.collectionPath,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(collectionPath)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final records = snapshot.data!.docs;

          return Container(
            height: 600,
            child: Column(
              children: [
                Text(
                  collectionPath == 'expenses' ? 'Expenses' : 'Income',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record =
                          records[index].data() as Map<String, dynamic>;
                      final amount = record['amount'];
                      final category = record['category'];
                      final date = record['date'] as Timestamp;

                      final formattedDate =
                          DateFormat.yMMMd().add_jm().format(date.toDate());

                      return ListTile(
                        title: Text('$category   Rs. $amount'),
                        subtitle: Text(formattedDate),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete Record'),
                                  content: Text(
                                      'Are you sure you want to delete this record?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () async {
                                        // Delete the record from Firestore
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .collection(collectionPath)
                                            .doc(records[index].id)
                                            .delete();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                TotalCard(
                  uid: uid,
                  collectionPath: collectionPath,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Text('Loading');
      },
    );
  }
}

class TotalCard extends StatelessWidget {
  final String uid;
  final String collectionPath;

  TotalCard({
    required this.uid,
    required this.collectionPath,
  });

  Future<double> calculateTotalForPreviousMonth() async {
    print('running');
    final now = DateTime.now();
    final previousMonth = DateTime(now.year, now.month - 1);
    final startOfMonth = DateTime(previousMonth.year, previousMonth.month, 1);
    final endOfMonth =
        DateTime(previousMonth.year, previousMonth.month + 1, 0, 23, 59, 59);

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(collectionPath)
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();
    final List<Expense> expenses = snapshot.docs.map((doc) {
      final data = doc.data() as Map;
      return Expense(
        amount: data['amount'],
        category: data['category'],
        date: (data['date'] as Timestamp).toDate(),
        note: data['note'],
      );
    }).toList();
    double total = 0;
    for (final expense in expenses) {
      total = total + double.parse(expense.amount);
    }
    print(total);
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: calculateTotalForPreviousMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final total = snapshot.data!;
          return Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      'Total $collectionPath in Month of ${DateFormat.MMMM().format(DateTime(DateTime.now().year, DateTime.now().month - 1))}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    trailing: Text(
                      'Rs. ${total.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: ListTile(
              title: Text('Total for Previous Month'),
              trailing: Text('N/A'),
            ),
          );
        }
      },
    );
  }
}
