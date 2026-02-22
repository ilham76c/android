import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  final Map<String, dynamic> profile;

  const OverviewTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final logoUrl =
        "https://www.idx.co.id${profile['logo_url']}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(logoUrl, height: 80),
          const SizedBox(height: 16),
          Text(profile['sector'], style: Theme.of(context).textTheme.titleLarge),
          Text(profile['industry']),
          const SizedBox(height: 12),
          Text("Main Business"),
          Text(profile['main_business'] ?? ''),
          const SizedBox(height: 12),
          Text("Website: ${profile['website']}"),
          Text("Email: ${profile['email']}"),
          Text("Phone: ${profile['phone']}"),
        ],
      ),
    );
  }
}