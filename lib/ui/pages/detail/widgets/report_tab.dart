import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_cubit.dart';
import 'package:simple_accounting_offline/ui/routes/route_name.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 20.0,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(
                  RouteName.pdfJourneyBook,
                  queryParams: {
                    'start_date': DateFormat('yyyy-MM-dd').format(
                      context.read<DetailCubit>().state.startDate,
                    ),
                    'end_date': DateFormat('yyyy-MM-dd').format(
                      context.read<DetailCubit>().state.endDate,
                    ),
                  },
                );
              },
              icon: const Icon(Icons.book_outlined),
              label: Text(AppLocalizations.of(context)!.journalBook),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(
                  RouteName.pdfIncomeStatement,
                  queryParams: {
                    'start_date': DateFormat('yyyy-MM-dd').format(
                      context.read<DetailCubit>().state.startDate,
                    ),
                    'end_date': DateFormat('yyyy-MM-dd').format(
                      context.read<DetailCubit>().state.endDate,
                    ),
                  },
                );
              },
              icon: const Icon(Icons.monetization_on_outlined),
              label: Text(AppLocalizations.of(context)!.incomeStatement),
            ),
          ],
        ),
      ),
    );
  }
}
