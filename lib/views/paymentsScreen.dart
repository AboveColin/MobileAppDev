import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastPayment {
  final String status;
  final DateTime date;
  final double amount;

  PastPayment({required this.status, required this.date, required this.amount});
}

class PastPaymentsScreen extends StatefulWidget {
  const PastPaymentsScreen({Key? key}) : super(key: key);

  @override
  _PastPaymentsScreenState createState() => _PastPaymentsScreenState();
}

class _PastPaymentsScreenState extends State<PastPaymentsScreen> {
  // Sample data
  final List<PastPayment> pastPayments = [
    PastPayment(
        status: "Completed",
        date: DateTime.now().subtract(Duration(days: 30)),
        amount: 425.24),
    PastPayment(
        status: "Completed",
        date: DateTime.now().subtract(Duration(days: 60)),
        amount: 400.00),
    PastPayment(
        status: "Completed",
        date: DateTime.now().subtract(Duration(days: 90)),
        amount: 240.00),
    PastPayment(
        status: "Open",
        date: DateTime.now().subtract(Duration(days: 140)),
        amount: 240.00),
  ];

  double get totalPayments =>
      pastPayments.fold(0.0, (sum, item) => sum + item.amount);

  double get totalCompletedPayments => pastPayments
      .where((element) => element.status == "Completed")
      .fold(0.0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    final double progress = totalCompletedPayments / totalPayments;
    final bool isComplete = progress == 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Payments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Payments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '€${totalCompletedPayments.toStringAsFixed(2)}/ €${totalPayments.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      isComplete ? Colors.green : Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pastPayments.length,
              itemBuilder: (context, index) {
                final payment = pastPayments[index];
                return ListTile(
                  leading: Icon(Icons.payment,
                      size: 40), // Replace with your image asset
                  title: Text(
                    DateFormat('yMMMd').format(payment.date),
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        payment.status,
                        style: TextStyle(
                            fontSize: 16,
                            color: payment.status == "Completed"
                                ? Colors.green
                                : Colors.red),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        payment.status == "Completed"
                            ? Icons.check_circle
                            : Icons.error,
                        color: payment.status == "Completed"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),

                  trailing: Text(
                    "€${payment.amount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
