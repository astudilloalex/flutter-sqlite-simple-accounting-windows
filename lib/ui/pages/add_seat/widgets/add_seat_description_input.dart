import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_form_cubit.dart';

class AddSeatDescriptionInput extends StatelessWidget {
  const AddSeatDescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 4,
      minLines: 3,
      maxLength: 500,
      onChanged: (value) {
        context.read<AddSeatFormCubit>().description = value;
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)!.invalidDescription;
        }
        return null;
      },
    );
  }
}
