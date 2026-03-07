import 'package:flutter/material.dart';

import '../data/ownership_service.dart';
import '../model/ownership_model.dart';
import '../widgets/ownership_line_chart.dart';

class OwnershipScreen extends StatefulWidget {
  const OwnershipScreen({super.key});

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen> {

  late Future<OwnershipChartResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = OwnershipService.fetchChart("JAYA");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ownership Chart")),
      body: FutureBuilder<OwnershipChartResponse>(
        future: _future,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  data.ticker,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Ownership Trend",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: OwnershipLineChart(data: data),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}