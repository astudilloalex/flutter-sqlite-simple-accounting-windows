import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/detail/widgets/report_tab.dart';
import 'package:simple_accounting_offline/ui/pages/detail/widgets/seat_tab.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: ElevatedButton(
            onPressed: () {
              showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 182)),
                lastDate: DateTime.now().add(const Duration(days: 182)),
                initialDateRange: DateTimeRange(
                  start: context.read<DetailCubit>().state.startDate,
                  end: context.read<DetailCubit>().state.endDate,
                ),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                builder: (context, child) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600.0,
                        maxHeight: 600.0,
                      ),
                      child: ListView(
                        children: [
                          Theme(
                            data: ThemeData(),
                            child: child!,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).then((value) {
                if (value == null) return;
                context.read<DetailCubit>().changeDates(value);
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(
                    context.watch<DetailCubit>().state.startDate,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                const Icon(Icons.arrow_forward_ios_outlined, size: 18.0),
                const SizedBox(width: 16.0),
                Text(
                  DateFormat('dd/MM/yyyy').format(
                    context.watch<DetailCubit>().state.endDate,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: AppLocalizations.of(context)!.seats,
              ),
              Tab(
                text: AppLocalizations.of(context)!.reports,
              )
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            SeatTab(),
            ReportTab(),
          ],
        ),
      ),
    );
  }
}
