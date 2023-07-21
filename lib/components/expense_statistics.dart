import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class Expense {
  final String amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });
}

Map<String, double> calculateCategoryTotals(List<Expense> expenses) {
  final Map<String, double> categoryTotals = {};

  for (final expense in expenses) {
    if (categoryTotals.containsKey(expense.category)) {
      categoryTotals[expense.category] =
          categoryTotals[expense.category]! + double.parse(expense.amount);
    } else {
      categoryTotals[expense.category] = double.parse(expense.amount);
    }
  }

  return categoryTotals;
}

Future<List<Expense>> fetchExpensesForMonth(DateTime month, String uid) async {
  final previousMonth = DateTime(month.year, month.month - 1);
  final startOfMonth = DateTime(previousMonth.year, previousMonth.month, 1);
  final endOfMonth =
      DateTime(previousMonth.year, previousMonth.month + 1, 0, 23, 59, 59);

  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('expenses')
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
  print(expenses);
  return expenses;
}

class ExpensePieChart extends StatelessWidget {
  final DateTime month;
  final String uid;

  ExpensePieChart(this.month, this.uid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: fetchExpensesForMonth(month, uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final expenses = snapshot.data!;
          final categoryTotals = calculateCategoryTotals(expenses);

          return PieChart(
            PieChartData(
              sections: categoryTotals.entries.map((entry) {
                return PieChartSectionData(
                  color: getRandomColor(),
                  value: entry.value,
                  title: entry.key,
                  radius: 80,
                  titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                );
              }).toList(),
              centerSpaceRadius: 50,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Color getRandomColor() {
    return Color((DateTime.now().microsecondsSinceEpoch / 1000).toInt())
        .withOpacity(0.8);
  }
}
