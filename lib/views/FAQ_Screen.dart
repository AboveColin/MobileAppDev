import 'package:flutter/material.dart';
import 'package:mobileappdev/views/SupportTicketScreen.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  late Future<List<dynamic>> faqs;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    faqs = fetchFAQs();
  }

  Future<List<dynamic>> fetchFAQs() async {
    // example list
    return [
      {
        "question": "How do I rent a car?",
        "answer":
            "You can rent a car by going to the Cars tab and selecting a car to rent. You will be prompted to enter your payment information and then you can rent the car."
      },
      {
        "question": "How do I return a car?",
        "answer":
            "You can return a car by going to the Cars tab and selecting a car to return. You will be prompted to enter your payment information and then you can return the car."
      },
      {
        "question": "How do I report damage to a car?",
        "answer":
            "You can report damage to a car by going to the Cars tab and selecting a car to report damage to. You will be prompted to enter your payment information and then you can report damage to the car."
      },
      {
        "question": "How do I contact support?",
        "answer":
            "You can contact support by going to the FAQs tab and selecting the Contact Support button. You will be prompted to enter your payment information and then you can contact support."
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search FAQs",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Implement search logic if needed
                  },
                ),
              ),
              onChanged: (value) {
                // Implement dynamic search logic
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: faqs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var faq = snapshot.data![index];
                        return FAQItem(
                          question: faq['question'],
                          answer: faq['answer'],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SupportTicketScreen()));
              },
              child: const Text('Contact Support'),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isHelpful = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.question),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(widget.answer),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(isHelpful ? "Helpful" : "Was this helpful?"),
                onPressed: () {
                  setState(() {
                    isHelpful = !isHelpful;
                  });
                  // Implement logic to record feedback
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
