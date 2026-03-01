import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DividendsTab extends StatelessWidget {
  final List dividends;

  const DividendsTab({super.key, required this.dividends});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dividends.length,
      itemBuilder: (_, i) {
        final d = dividends[i];
        final String cumDate = DateFormat('dd MMM yyyy').format(DateTime.parse(d['cum_date']));
        final String recordDate = DateFormat('dd MMM yyyy').format(DateTime.parse(d['record_date']));
        final String distributionDate = DateFormat('dd MMM yyyy').format(DateTime.parse(d['distribution_date']));
        
        return Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Semakin besar angka, semakin bulat
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      d['type'], 
                      style: const TextStyle(fontSize: 12)
                    ),
                    Text(
                      "${d['currency']} ${d['dividend_per_share'].toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 12)
                    )
                  ]
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Cum Date", 
                      style: TextStyle(fontSize: 12)
                    ),
                    Text(
                      cumDate,
                      style: const TextStyle(fontSize: 12)
                    )
                  ]
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Record Date", 
                      style: TextStyle(fontSize: 12)
                    ),
                    Text(
                      recordDate,
                      style: const TextStyle(fontSize: 12)
                    )
                  ]
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Distribution Date", 
                      style: TextStyle(fontSize: 12)
                    ),
                    Text(
                      distributionDate,
                      style: const TextStyle(fontSize: 12)
                    )
                  ]
                )
              ]
            )
          )
        );
      },
    );
  }
}
