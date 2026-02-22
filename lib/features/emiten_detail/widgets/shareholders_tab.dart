import 'package:flutter/material.dart';

class ShareholdersTab extends StatelessWidget {
  final List shareholders;

  const ShareholdersTab({super.key, required this.shareholders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: shareholders.length,
      itemBuilder: (_, i) {
        final s = shareholders[i];

        return ListTile(
          title: Text(s['name']),
          subtitle: Text("${s['category']} • ${s['percentage']}%"),
          trailing: s['is_controller']
              ? const Icon(Icons.star, color: Colors.amber)
              : null,
        );
      },
    );
  }
}