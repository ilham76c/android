import 'package:flutter/material.dart';
import '../services/emiten_detail_service.dart';
import '../widgets/overview_tab.dart';
import '../widgets/dividends_tab.dart';
import '../widgets/shareholders_tab.dart';
import '../widgets/subsidiaries_tab.dart';

class EmitenDetailPage extends StatelessWidget {
  final String ticker;

  const EmitenDetailPage({super.key, required this.ticker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ticker)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: EmitenDetailService.fetchDetail(ticker),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;

          return DefaultTabController(
            length: 4,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "Dividends"),
                    Tab(text: "Shareholders"),
                    Tab(text: "Subsidiaries"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      OverviewTab(profile: data['profile']),
                      DividendsTab(dividends: data['dividends']),
                      ShareholdersTab(shareholders: data['shareholders']),
                      SubsidiariesTab(subsidiaries: data['subsidiaries']),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}