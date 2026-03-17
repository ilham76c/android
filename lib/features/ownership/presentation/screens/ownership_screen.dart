import 'package:flutter/material.dart';
import '../state/ownership_controller.dart';
import '../widgets/charts/ownership_line_chart.dart';
import '../../domain/usecases/get_ownership_chart.dart';
import '../../data/datasource/ownership_remote_datasource.dart';
import '../../data/repositories/ownership_repository_impl.dart';

class OwnershipScreen extends StatefulWidget {
  const OwnershipScreen({super.key});

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen> {
  late OwnershipController controller;

  @override
  void initState() {
    super.initState();

    final repository = OwnershipRepositoryImpl(
      OwnershipRemoteDataSource(),
    );

    final usecase = GetOwnershipChart(repository);

    controller = OwnershipController(usecase);

    controller.load("SSIA");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ownership Chart")),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {

          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(child: Text(controller.error!));
          }

          final data = controller.data!;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(data.ticker,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),

                const SizedBox(height: 12),

                Expanded(
                  child: OwnershipLineChart(data: data),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}