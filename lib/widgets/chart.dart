import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recenTransactions;

  Chart(this.recenTransactions);

  List<Map<String, Object>>? get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recenTransactions.length; i++) {
        if (recenTransactions[i].date.day == weekDay.day &&
            recenTransactions[i].date.month == weekDay.month &&
            recenTransactions[i].date.year == weekDay.year) {
          totalSum += recenTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsValues!.fold(
      0.0,
      (previousValue, element) => previousValue + (element['amount'] as double),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionsValues!.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: Chartbar(
                data['day'] as String,
                data['amount'] as double,
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
