import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/market_snapshot_card.dart';
import '../widgets/watchlist_item.dart';
import '../../emiten_detail/screens/emiten_detail_page.dart';

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
          children: [
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
              ticker: "BBCA",
              change: "+4.3M",
              positive: true,
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmitenDetailPage(
                      ticker: "BBCA",
                    ),
                  ),
                );
              },
            ),
            WatchlistItem(
              ticker: "ASII",
              change: "-1.2M",
              positive: false,
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmitenDetailPage(
                      ticker: "ASII",
                    ),
                  ),
                );
              },
            ),
            WatchlistItem(
              ticker: "PTBA",
              change: "-1.2M",
              positive: false,
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmitenDetailPage(
                      ticker: "PTBA",
                    ),
                  ),
                );
              },
            ),
            WatchlistItem(
              ticker: "ADRO",
              change: "-1.2M",
              positive: false,
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmitenDetailPage(
                      ticker: "ADRO",
                    ),
                  ),
                );
              },
            ),
            WatchlistItem(
              ticker: "BUMI",
              change: "-1.2M",
              positive: false,
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmitenDetailPage(
                      ticker: "BUMI",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
