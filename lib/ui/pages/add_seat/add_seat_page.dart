import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_form.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/seat_detail_table.dart';

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
                              '${AppLocalizations.of(context)!.debit}\n${context.watch<AddSeatCubit>().state.totalDebit}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.teal,
                              thickness: 5,
                              width: 20.0,
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.credit}\n${context.watch<AddSeatCubit>().state.totalCredit}',
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
                            ? () {}
                            : null,
                    label: Text(AppLocalizations.of(context)!.save),
                    icon: const Icon(Icons.save_outlined),
                  ),
                  const SizedBox(width: 20.0),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Text(AppLocalizations.of(context)!.cancel),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
