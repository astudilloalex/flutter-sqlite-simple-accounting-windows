import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_state.dart';

class PeriodList extends StatelessWidget {
  const PeriodList({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsState state = context.watch<SettingsCubit>().state;
    if (state.loading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return ListView.builder(
      itemCount: state.periods.length,
      itemBuilder: (context, index) {
        final AccountingPeriod period = state.periods[index];
        return ListTile(
          title: Text(period.name),
        );
      },
    );
  }
}
