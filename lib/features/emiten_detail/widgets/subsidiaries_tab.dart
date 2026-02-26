import 'package:flutter/material.dart';

class SubsidiariesTab extends StatelessWidget {
  final List subsidiaries;

  const SubsidiariesTab({super.key, required this.subsidiaries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: subsidiaries.length,
      itemBuilder: (_, i) {
        final s = subsidiaries[i];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 5.0,
          child: ListTile(
            title: Text(s['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
            subtitle: Text("${s['business_line']} • ${s['location']}",
                style: const TextStyle(
                  color: Color(0xFFCED4DA),
                  fontSize: 12,
                )),
            trailing: Text("${s['ownership_percentage']}%",
                style: const TextStyle(
                  color: Color(0xFFCED4DA),
                  fontSize: 12,
                )),
          ),
        );
      },
    );
  }
}
