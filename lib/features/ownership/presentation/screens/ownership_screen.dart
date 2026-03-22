import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();

    final repository = OwnershipRepositoryImpl(
      OwnershipRemoteDataSource(),
    );

    final usecase = GetOwnershipChart(repository);

    controller = OwnershipController(usecase);

    // 🔥 default: 1 bulan terakhir
    final now = DateTime.now();

    _selectedRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );

    controller.loadWithRange(
      "SSIA",
      startDate: _selectedRange!.start,
      endDate: _selectedRange!.end,
    );
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

                // Text(
                //   "${_formatDate(_selectedRange!.start)} - ${_formatDate(_selectedRange!.end)}",
                // ),
                OutlinedButton.icon(
                  onPressed: _pickDateRange,
                  icon: const Icon(Icons.date_range, size: 16),
                  label: Text(
                    _selectedRange == null
                        ? "Filter"
                        : "${_formatDate(_selectedRange!.start)} - ${_formatDate(_selectedRange!.end)}",
                  ),
                ),

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

  Future<void> _reloadData() async {
    controller.loadWithRange(
      "JAYA",
      startDate: _selectedRange?.start,
      endDate: _selectedRange?.end,
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _selectedRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
    );

    if (picked != null) {
      setState(() {
        _selectedRange = picked;
      });

      controller.loadWithRange(
        "SSIA",
        startDate: picked.start,
        endDate: picked.end,
      );
    }
  }
}