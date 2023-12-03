import 'package:flutter/material.dart';
import 'package:mobileappdev/helpers/ApiService.dart';

class DamageReportsOverviewScreen extends StatefulWidget {
  @override
  _DamageReportScreenState createState() => _DamageReportScreenState();
}

class _DamageReportScreenState extends State<DamageReportsOverviewScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> damageReportsFuture;

  @override
  void initState() {
    super.initState();
    damageReportsFuture = _apiService.fetchDamageReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Damage Reports"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: damageReportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var reports = snapshot.data!;
              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  var report = reports[index];
                  return ListTile(
                    title: Text(report['description']),
                    subtitle: Text("Car ID: ${report['car_id']}"),
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: Image.network(report['image_url']),
                          ),
                        );
                      },
                      child: Image.network(report['image_url']),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
