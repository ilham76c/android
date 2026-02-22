import 'package:flutter/material.dart';

class DividendsTab extends StatelessWidget {
  final List dividends;

  const DividendsTab({super.key, required this.dividends});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dividends.length,
      itemBuilder: (_, i) {
        final d = dividends[i];
        return Card(
          child: ListTile(
            title: Text("FY ${d['fiscal_year']}"),
            subtitle: Text(
                "DPS: ${d['cash_dividend_per_share']} ${d['cash_dividend_currency']}"),
            trailing: Text(d['type']),
          ),
        );
      },
    );
  }
}