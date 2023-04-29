import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';

class AddSeatPeriodDropdown extends StatelessWidget {
  const AddSeatPeriodDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.period,
      ),
      items: context
          .watch<AddSeatCubit>()
          .state
          .periods
          .map(
            (period) => DropdownMenuItem<int?>(
              value: period.id,
              child: Text(
                '${DateFormat('MMMM dd, yyyy').format(period.startDate)} - ${DateFormat('MMMM dd, yyyy').format(period.endDate)}',
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        context.read<AddSeatCubit>().changePeriod(value);
      },
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)!.selectAPeriod;
        }
        return null;
      },
      value: context.watch<AddSeatCubit>().state.periods.firstOrNull?.id,
    );
  }
}
