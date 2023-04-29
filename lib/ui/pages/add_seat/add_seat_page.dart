import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/app/app.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_detail_button.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_form.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/seat_detail_table.dart';
import 'package:simple_accounting_offline/ui/pages/home/cubit/home_cubit.dart';

class AddSeatPage extends StatelessWidget {
  const AddSeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: AddSeatForm(),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: AddSeatDetailButton(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200.0),
                child: const SeatDetailTable(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200.0),
              child: Row(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.debit}\n${NumberFormat('#,##0.00').format(double.parse(context.watch<AddSeatCubit>().state.totalDebit))}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.teal,
                              thickness: 5,
                              width: 40.0,
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.credit}\n${NumberFormat('#,##0.00').format(double.parse(context.watch<AddSeatCubit>().state.totalCredit))}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        context.watch<AddSeatCubit>().state.totalCredit ==
                                context.watch<AddSeatCubit>().state.totalDebit
                            ? () => _save(context)
                            : null,
                    label: Text(AppLocalizations.of(context)!.save),
                    icon: const Icon(Icons.save_outlined),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final String? error = await context.read<AddSeatCubit>().saveSeat();
    if (context.mounted) {
      if (error != null) {
        showErrorSnackbar(context, error);
      } else {
        context.read<HomeCubit>().changeCurrentIndex(0);
      }
    }
  }
}
