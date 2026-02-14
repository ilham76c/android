import 'package:flutter/material.dart';
import '../data/ownership_mock_data.dart';
import '../widgets/ownership_line_chart.dart';
import '../widgets/ownership_change_chart.dart';

class OwnershipScreen extends StatelessWidget {
  const OwnershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = getMockOwnership();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ownership Chart"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: OwnershipLineChart(data: data),
          ),
          Expanded(
            flex: 1,
            child: OwnershipChangeChart(data: data),
          ),
        ],
      ),
    );
  }
}
