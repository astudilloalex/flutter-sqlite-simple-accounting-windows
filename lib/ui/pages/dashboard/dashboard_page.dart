import 'package:flutter/material.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/widgets/statement_income_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Wrap(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600.0),
                child: const StatementIncomeChart(),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600.0),
                child: const StatementIncomeChart(isIncomeChart: false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
