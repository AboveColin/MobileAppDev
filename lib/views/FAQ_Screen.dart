import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          FAQItem(
            question: "How do I reserve a car?",
            answer:
                "You can reserve a car using our mobile app or website. Just select the car you want and choose the reservation time.",
          ),
          FAQItem(
            question: "What are the costs involved?",
            answer:
                "Costs include a per-minute rate during use, and there are no monthly fees. Fuel, insurance, and parking are included.",
          ),
          FAQItem(
            question: "Can I cancel my reservation?",
            answer:
                "Yes, you can cancel your reservation free of charge up to 15 minutes before the scheduled start time.",
          ),
          // Add more FAQs here
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(question),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}