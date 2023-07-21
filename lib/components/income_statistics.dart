import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class Income {
  final String amount;
  final String category;
  final DateTime date;
  final String note;

  Income({
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });
}

Map<String, double> calculateCategoryTotals(List<Income> incomes) {
  final Map<String, double> categoryTotals = {};

  for (final income in incomes) {
    if (categoryTotals.containsKey(income.category)) {
      categoryTotals[income.category] =
          categoryTotals[income.category]! + double.parse(income.amount);
    } else {
      categoryTotals[income.category] = double.parse(income.amount);
    }
  }

  return categoryTotals;
}

Future<List<Income>> fetchIncomesForMonth(DateTime month, String uid) async {
  final startOfMonth = DateTime(month.year, month.month, 1);
  final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('income')
      .where('date', isGreaterThanOrEqualTo: startOfMonth)
      .where('date', isLessThanOrEqualTo: endOfMonth)
      .get();

  final List<Income> incomes = snapshot.docs.map((doc) {
    final data = doc.data() as Map;
    return Income(
      amount: data['amount'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'],
    );
  }).toList();
  print(incomes);
  return incomes;
}

class IncomePieChart extends StatelessWidget {
  final DateTime month;
  final String uid;

  IncomePieChart(this.month, this.uid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Income>>(
      future: fetchIncomesForMonth(month, uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final incomes = snapshot.data!;
          final categoryTotals = calculateCategoryTotals(incomes);

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
