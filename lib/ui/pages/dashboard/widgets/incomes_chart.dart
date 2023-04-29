import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:simple_accounting_offline/app/app.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/cubit/dashboard_state.dart';

class IncomesChart extends StatelessWidget {
  const IncomesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 12,
      child: Card(
        color: const Color(0xFF272953),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.incomes,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Expanded(
                child: _BarChart(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    final DashboardState state = context.watch<DashboardCubit>().state;
    return BarChart(
      BarChartData(
        barGroups: state.sixMonthsIncomes.mapIndexed((e, index) {
          return BarChartGroupData(
            x: e,
            barRods: [
              BarChartRodData(
                toY: index.toDouble(),
                width: 25.0,
                color: Colors.white,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  color: Colors.white.darken().withOpacity(0.3),
                ),
              ),
            ],
          );
        }).toList(),
        borderData: FlBorderData(
          show: false,
        ),
        gridData: FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.darken().withOpacity(0.2),
              strokeWidth: 1.0,
            );
          },
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50.0,
              getTitlesWidget: (value, meta) {
                return Text(
                  ' ${meta.formattedValue}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38.0,
              getTitlesWidget: (value, meta) {
                final Jiffy start = Jiffy().subtract(months: 5);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat('MMM').format(
                      start.add(months: value.truncate()).dateTime,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
