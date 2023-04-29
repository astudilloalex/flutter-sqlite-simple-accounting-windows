import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_detail_dialog.dart';

class AddSeatDetailButton extends StatelessWidget {
  const AddSeatDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: () {
            showDialog<SeatDetail?>(
              context: context,
              builder: (_) {
                return const AddSeatDetailDialog();
              },
              barrierDismissible: false,
            ).then((value) {
              if (value == null) return;
              context.read<AddSeatCubit>().addOrUpdateSeatDetail(value);
            });
          },
          label: Text(AppLocalizations.of(context)!.add),
          icon: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }
}
