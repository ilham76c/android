import 'package:flutter/material.dart';

class SubsidiariesTab extends StatelessWidget {
  final List subsidiaries;

  const SubsidiariesTab({super.key, required this.subsidiaries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subsidiaries.length,
      itemBuilder: (_, i) {
        final s = subsidiaries[i];

        return Card(
          child: ListTile(
            title: Text(s['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
            subtitle: Text("${s['business_line']} • ${s['location']}",
                style: const TextStyle(
                  color: Color(0xFFCED4DA),
                  fontSize: 13,
                )),
            trailing: Text("${s['ownership_percentage']}%",
                style: const TextStyle(
                  color: Color(0xFFCED4DA),
                  fontSize: 13,
                )),
          ),
        );
      },
    );
  }
}
