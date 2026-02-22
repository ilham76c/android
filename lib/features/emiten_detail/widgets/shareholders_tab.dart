import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareholdersTab extends StatelessWidget {
  final List shareholders;

  const ShareholdersTab({super.key, required this.shareholders});

  @override
  Widget build(BuildContext context) {
    final direksi =
        shareholders.where((s) => s['category'] == "Direksi").toList();

    final komisaris =
        shareholders.where((s) => s['category'] == "Komisaris").toList();

    final majorHolders =
        shareholders.where((s) => s['category'] == "Lebih dari 5%").toList();

    final others = shareholders.where((s) =>
        s['category'] != "Direksi" &&
        s['category'] != "Komisaris" &&
        s['category'] != "Lebih dari 5%").toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection("Direksi", direksi),
        _buildSection("Komisaris", komisaris),
        _buildSection("Pemegang Saham >5%", majorHolders),
        _buildSection("Lainnya", others),
      ],
    );
  }

  Widget _buildSection(String title, List data) {
    if (data.isEmpty) return const SizedBox();

    final formatter = NumberFormat("#,###");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...data.map((s) => Card(
              child: ListTile(
                title: Text(
                  s['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: s['is_controller'] 
                  ? const Text(
                      "Pengendali", 
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ) 
                  : s['position'] != null? Text(
                      "${s['position']}", 
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      )) : const Text("-", style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      )),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${s['percentage']}%"),
                    Text("${formatter.format(s['shares_count'])} shares"),
                  ],
                )
              ),
            )),
      ],
    );
  }
}
