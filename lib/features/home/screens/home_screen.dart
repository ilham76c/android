import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/market_snapshot_card.dart';
import '../widgets/watchlist_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EquityLens",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            SearchBarWidget(),
            SizedBox(height: 20),
            MarketSnapshotCard(),
            SizedBox(height: 20),
            Text(
              "Watchlist",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            WatchlistItem(
              ticker: "MSIN",
              change: "+4.3M",
              positive: true,
            ),
            WatchlistItem(
              ticker: "JAYA",
              change: "-1.2M",
              positive: false,
            ),
          ],
        ),
      ),
    );
  }
}
