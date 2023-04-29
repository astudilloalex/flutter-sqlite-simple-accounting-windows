import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';

class AddSeatDateInput extends StatelessWidget {
  const AddSeatDateInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.teal,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          final DateTime now = DateTime.now();
          showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(now.year),
            lastDate: DateTime(now.year, 12, 31),
          ).then((date) {
            if (date == null) return;
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then((time) {
              if (time == null) return;
              context.read<AddSeatCubit>().changeDate(
                    DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ),
                  );
            });
          });
        },
        child: SizedBox(
          height: 55.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                AppLocalizations.of(context)!.date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy HH:mm').format(
                  context.watch<AddSeatCubit>().state.date,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
