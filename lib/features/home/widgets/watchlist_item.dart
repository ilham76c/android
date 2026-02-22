import 'package:flutter/material.dart';

class WatchlistItem extends StatelessWidget {
  final String ticker;
  final String change;
  final bool positive;
  final VoidCallback? onTap;

  const WatchlistItem({
    super.key,
    required this.ticker,
    required this.change,
    required this.positive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(ticker),
        trailing: Text(
          change,
          style: TextStyle(
            color: positive ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}