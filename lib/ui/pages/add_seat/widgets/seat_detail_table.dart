import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_state.dart';

class SeatDetailTable extends StatelessWidget {
  const SeatDetailTable({super.key});

  @override
  Widget build(BuildContext context) {
    final AddSeatState state = context.watch<AddSeatCubit>().state;
    if (state.seatDetails.isEmpty) {
      return const SizedBox();
    }
    return Scrollbar(
      scrollbarOrientation: ScrollbarOrientation.right,
      child: SingleChildScrollView(
        primary: true,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad
            },
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200.0),
              child: DataTable(
                horizontalMargin: 16.0,
                columnSpacing: 16.0,
                headingRowColor: MaterialStatePropertyAll(
                  Colors.teal.withOpacity(0.1),
                ),
                border: TableBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  top: const BorderSide(),
                  bottom: const BorderSide(),
                  right: const BorderSide(),
                  left: const BorderSide(),
                  horizontalInside: const BorderSide(),
                  verticalInside: const BorderSide(),
                ),
                columns: [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.code,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.account,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.debit,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.credit,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.document,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.actions,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                rows: state.seatDetails.map((detail) {
                  return DataRow(
                    cells: [
                      DataCell(Text(detail.account?.code ?? '')),
                      DataCell(
                        SingleChildScrollView(
                          child: Text(detail.account?.name ?? ''),
                        ),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            Decimal.parse(detail.debit.toString()) ==
                                    Decimal.zero
                                ? ''
                                : NumberFormat('#,##0.00').format(
                                    Decimal.parse(detail.debit.toString())
                                        .toDouble(),
                                  ),
                          ),
                        ),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            Decimal.parse(detail.credit.toString()) ==
                                    Decimal.zero
                                ? ''
                                : NumberFormat('#,##0.00').format(
                                    Decimal.parse(detail.credit.toString())
                                        .toDouble(),
                                  ),
                          ),
                        ),
                      ),
                      DataCell(
                        SingleChildScrollView(
                          child: SizedBox(
                            width: 350.0,
                            child: Text(detail.description ?? ''),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(detail.documentNumber ?? ''),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            ),
                            const SizedBox(width: 10.0),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
