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
    final direksi =
        managements.where((m) => m['role_group'] == "Direksi").toList();

    final komisaris =
        managements.where((m) => m['role_group'] == "Komisaris").toList();

    final komiteAudit =
        committees.where((c) => c['committee_type'] == "Komite Audit").toList();

    final prices = generateIntradayData();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== HEADER =====
          Row(
            children: [
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
            decoration: BoxDecoration(
              color: const Color(0xFF111418),
              borderRadius: BorderRadius.circular(16),
            ),
            child: AdvancedStockChart(prices: prices),
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
              ...buildSection(context, "Direksi", direksi),
            ],
          ),

          const SizedBox(height: 16),

          _buildCard(
            context,
            title: "Commissioners",
            children: [
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

  List<double> generateIntradayData() {
    final random = Random();
    double firstPrice = 1000;
    final List<double> data = [];

    for (int i = 0; i < 20; i++) {
      firstPrice += random.nextDouble() * 8 - 4;
      data.add(firstPrice);
    }

    return data;
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              )),
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
              child: Text(label, style: const TextStyle(color: Colors.grey))),
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

class AdvancedStockChart extends StatelessWidget {
  final List<double> prices;

  const AdvancedStockChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    final lastPrice = prices.last;
    final firstPrice = prices.first;
    final change = lastPrice - firstPrice;
    final percent = (change / firstPrice) * 100;
    final isDown = change < 0;

    final maxPrice = prices.reduce(max);
    final minPrice = prices.reduce(min);

    // 👇 paksa kelipatan 10
    final double minY = (minPrice ~/ 10) * 10;
    final double maxY = ((maxPrice ~/ 10) + 1) * 10;
    final double maxX = prices.length.toDouble();

    final double reservedWidth = calculateRightTitleWidth(
      minY: minY,
      maxY: maxY,
      interval: 10,
    );

    final scale = calculateAxisScale(prices);

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PRICE HEADER
            Text(
              lastPrice.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "${change.toStringAsFixed(0)} (${percent.toStringAsFixed(2)}%)",
              style: TextStyle(
                fontSize: 16,
                color: isDown ? Colors.red : Colors.green,
              ),
            ),

            const SizedBox(height: 24),

            /// CHART
            AspectRatio(
              aspectRatio: 2.5,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.black,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),

                  minY: scale.minY,
                  maxY: scale.maxY,
                  maxX: maxX,

                  /// Y AXIS
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: reservedWidth,
                        interval: scale.interval, // 👈 kelipatan 10
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  /// DASHED LAST PRICE LINE
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: lastPrice,
                        color: Colors.grey.withOpacity(0.4),
                        strokeWidth: 1,
                        dashArray: [6, 6],
                      ),
                    ],
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        prices.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          prices[index],
                        ),
                      ),
                      isCurved: false,
                      color: isDown ? Colors.red : Colors.green,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),

                      /// GRADIENT FILL
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            (isDown ? Colors.red : Colors.green)
                                .withOpacity(0.4),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// RANGE SELECTOR
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _RangeButton("1D", selected: true),
                _RangeButton("1W"),
                _RangeButton("1M"),
                _RangeButton("3M"),
                _RangeButton("YTD"),
                _RangeButton("1Y"),
              ],
            )
          ],
        ),

        /// BADGE
        const Positioned(
          top: 5,
          right: 5,
          child: _BoardBadge(label: "Papan Utama"),
        ),
      ]),
    );
  }
}

double getPriceFraction(double price) {
  if (price < 200) return 1;
  if (price < 500) return 2;
  if (price < 2000) return 5;
  if (price < 5000) return 10;
  return 25;
}

class AxisScale {
  final double minY;
  final double maxY;
  final double interval;

  AxisScale({
    required this.minY,
    required this.maxY,
    required this.interval,
  });
}

AxisScale calculateAxisScale(List<double> prices) {
  final double minPrice = prices.reduce((a, b) => a < b ? a : b);
  final double maxPrice = prices.reduce((a, b) => a > b ? a : b);

  final double fraction = getPriceFraction((minPrice + maxPrice) / 2);

  const int maxLabels = 6;

  final double range = maxPrice - minPrice;

  // interval minimum sesuai fraksi
  double interval = fraction;

  // naikkan interval sampai label <= maxLabels
  while ((range / interval).ceil() > maxLabels) {
    interval += fraction;
  }

  final double minY = (minPrice ~/ interval) * interval;
  final double maxY = ((maxPrice ~/ interval) + 1) * interval;

  return AxisScale(
    minY: minY,
    maxY: maxY,
    interval: interval,
  );
}

class _RangeButton extends StatelessWidget {
  final String label;
  final bool selected;

  const _RangeButton(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: selected ? Colors.green : Colors.grey,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

double calculateRightTitleWidth({
  required double minY,
  required double maxY,
  required double interval,
  TextStyle? style,
}) {
  final textStyle = style ??
      const TextStyle(
        fontSize: 11,
        color: Colors.grey,
      );

  double maxWidth = 0;

  for (double value = minY; value <= maxY; value += interval) {
    final text = value.toStringAsFixed(0);

    final tp = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    if (tp.width > maxWidth) {
      maxWidth = tp.width;
    }
  }

  return maxWidth + 5; // kasih sedikit padding
}

class _BoardBadge extends StatelessWidget {
  final String label;

  const _BoardBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
