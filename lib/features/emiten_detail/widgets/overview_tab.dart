import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';


class OverviewTab extends StatelessWidget {
  final Map<String, dynamic> profile;
  final List<double> sparklineData;
  final List managements;
  final List committees;

  const OverviewTab({
    super.key,
    required this.profile,
    required this.managements,
    required this.committees,
    required this.sparklineData,
  });

  @override
  Widget build(BuildContext context) {
    final logoUrl = "https://www.idx.co.id${profile['logo_url']}";
    final isPositive =
        sparklineData.isNotEmpty &&
        sparklineData.last >= sparklineData.first;

    final emaData = calculateEMA(sparklineData, 20);

    final priceSpots = List.generate(
      sparklineData.length,
      (i) => FlSpot(i.toDouble(), sparklineData[i]),
    );

    final emaSpots = List.generate(
      emaData.length,
      (i) => FlSpot(i.toDouble(), emaData[i]),
    );

    final direksi = managements?.where((m) => m['role_group'] == "Direksi").toList() ?? [];

    final komisaris = managements?.where((m) => m['role_group'] == "Komisaris").toList() ?? [];

    final komiteAudit = committees?.where((c) => c['committee_type'] == "Komite Audit").toList() ?? [];

    List<double> generateIntradayData() {
      final random = Random();
      double price = 4380;
      List<double> data = [];

      for (int i = 0; i < 120; i++) {
        price += random.nextDouble() * 8 - 4;
        data.add(price);
      }

      return data;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ===== HEADER =====
          Row(
            children: [
              // Image.network(logoUrl, height: 80),
              // const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile['name'] ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      profile['symbol'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          /// ===== PREMIUM MINI CHART =====
          Container(
            // padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111418),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TradingMiniChart(
              prices: generateIntradayData(),
            ),
          ),

          const SizedBox(height: 24),

          /// ===== BUSINESS CARD =====
          _buildCard(
            context,
            title: "Business Information",
            children: [
              _infoRow("Sector", profile['sector']),
              _infoRow("Industry", profile['industry']),
              _infoRow("Main Business", profile['main_business']),
            ],
          ),

          const SizedBox(height: 16),

          /// ===== CONTACT CARD =====
          _buildCard(
            context,
            title: "Contact",
            children: [
              _infoRow("Website", profile['website']),
              _infoRow("Email", profile['email']),
              _infoRow("Phone", profile['phone']),
            ],
          ),

          const SizedBox(height: 16),

          _buildCard(
            context,
            title: "Directors",
            children: [
              // ===== PROFILE SECTION =====
              // Text(
              //   profile['sector'] ?? "-",
              //   // style: Theme.of(context).textTheme.bodyMedium,
              // ),

              ...buildSection(context, "Direksi", direksi),
            ],
          ),

          const SizedBox(height: 16),

          _buildCard(
            context,
            title: "Commissioners",
            children: [
              // ===== PROFILE SECTION =====
              // Text(
              //   profile['sector'] ?? "-",
              //   // style: Theme.of(context).textTheme.bodyMedium,
              // ),

              ...buildSection(context, "Komisaris", komisaris),
            ],
          ),

          const SizedBox(height: 16),

          _buildCard(
            context,
            title: "Board Committees",
            children: [
              ...buildSection(context, "Komite Audit", komiteAudit),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15,)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child:
                  Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(
            flex: 5,
            child: Text(
              value.toString(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// ===== EMA CALCULATION =====
  List<double> calculateEMA(List<double> prices, int period) {
    if (prices.isEmpty) return [];

    List<double> ema = [];
    double multiplier = 2 / (period + 1);
    ema.add(prices.first);

    for (int i = 1; i < prices.length; i++) {
      double value =
          (prices[i] - ema[i - 1]) * multiplier + ema[i - 1];
      ema.add(value);
    }

    return ema;
  }
}

class TradingMiniChart extends StatelessWidget {
  final List<double> prices;

  const TradingMiniChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) return const SizedBox();

    final spots = List.generate(
      prices.length,
      (i) => FlSpot(i.toDouble(), prices[i]),
    );

    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final currentPrice = prices.last;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A1A3A),
            Color(0xFF08122B),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minY: minY - 10,
            maxY: maxY + 10,

            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (maxY - minY) / 4,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: prices.length / 4,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
            ),

            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: currentPrice,
                  color: Colors.white38,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ],
            ),

            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: Colors.greenAccent,
                barWidth: 2,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.greenAccent.withOpacity(0.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


List<Widget> buildSection(
  BuildContext context,
  String title,
  List data,
) {
  if (data.isEmpty) return [];

  return data.map<Widget>((item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12), // 🔥 jarak antar item
      elevation: 3, // 🔥 depth
      color: Theme.of(context).colorScheme.surfaceVariant, // beda dikit
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(
          item['name'] ?? "-",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        subtitle: item['position'] != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "${item['position']}"
                  "${item['is_independent'] == true ? " • INDEPENDEN" : ""}",
                  style: TextStyle(
                    fontSize: 10,
                    // fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : null,
      ),
    );
  }).toList();
}