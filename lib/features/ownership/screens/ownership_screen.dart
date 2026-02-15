import 'package:flutter/material.dart';
import '../data/ownership_service.dart';
import '../widgets/ownership_line_chart.dart';
import '../model/ownership_model.dart';

class OwnershipScreen extends StatefulWidget {
  const OwnershipScreen({super.key});

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen> {
  late Future<List<OwnershipData>> _futureData;

  @override
  void initState() {
    super.initState();
    // _futureData = OwnershipService.fetchOwnership();
    _futureData = OwnershipService.fetchOwnership("KBAG");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ownership Chart")),
      body: FutureBuilder<List<OwnershipData>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final rawData = snapshot.data ?? [];

          // 1️⃣ Group per investor
          final Map<String, List<OwnershipData>> grouped = {};

          for (var item in rawData) {
            grouped.putIfAbsent(item.investor, () => []).add(item);
          }

          // 2️⃣ Ambil semua tanggal unik
          final allDates = rawData
              .map((e) => e.date)
              .toSet()
              .toList()
            ..sort();

          // 3️⃣ Align semua tanggal untuk setiap investor
          grouped.forEach((key, list) {
            list.sort((a, b) => a.date.compareTo(b.date));

            final mapByDate = {for (var d in list) d.date: d};

            double lastShares = 0;

            grouped[key] = allDates.map((date) {
              if (mapByDate.containsKey(date)) {
                lastShares = mapByDate[date]!.shares;
                return mapByDate[date]!;
              } else {
                return OwnershipData(
                  date: date,
                  investor: key,
                  investorType: '',
                  shares: lastShares, // 🔥 carry forward
                  sharesChange: 0,
                  cumulativeChange: 0,
                );
              }
            }).toList();
          });


          // 4️⃣ Kirim ke chart
          return OwnershipLineChart(data: grouped.values.expand((e) => e).toList());
        },
      ),
    );
  }
}
