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

          final List<double> dummySparklineData = [
            6200, 6220, 6180, 6300, 6350, 6400, 6380,
            6450, 6500, 6480, 6550, 6600, 6620, 6700,
            6750, 6800, 6780, 6850, 6900, 6950,
          ];

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
                      // OverviewTab(profile: data['profile']),
                      OverviewTab(
                        profile: data['profile'],
                        managements: data['managements'],
                        committees: data['committees'],
                        sparklineData: data['chart_close_prices'] ?? dummySparklineData, // List<double>
                      ),
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