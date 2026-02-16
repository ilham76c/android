import 'package:flutter/material.dart';

class MarketSnapshotCard extends StatelessWidget {
  const MarketSnapshotCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Market Snapshot",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text("Top Buyer: MSIN  +4.3M",
              style: TextStyle(color: Colors.green)),
          Text("Top Seller: JAYA  -1.2M",
              style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
