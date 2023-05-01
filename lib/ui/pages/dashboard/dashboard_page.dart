import 'package:flutter/material.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/widgets/incomes_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: const IncomesChart(),
        ),
      ],
    );
  }
}
