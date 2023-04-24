import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/settings/widgets/add_edit_period_dialog.dart';
import 'package:simple_accounting_offline/ui/pages/settings/widgets/period_list.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          onTap: (value) {
            context.read<SettingsCubit>().load(value);
          },
          isScrollable: true,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!.accountingPeriods,
            ),
            Tab(
              text: AppLocalizations.of(context)!.users,
            ),
          ],
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            PeriodList(),
            Icon(Icons.reorder),
          ],
        ),
        floatingActionButton:
            context.watch<SettingsCubit>().state.currentTab != 0
                ? null
                : FloatingActionButton.extended(
                    onPressed: () => _onAddButton(context),
                    label: Text(AppLocalizations.of(context)!.add),
                    icon: const Icon(Icons.add),
                  ),
      ),
    );
  }

  void _onAddButton(BuildContext context) {
    showDialog<AccountingPeriod?>(
      context: context,
      builder: (context) => const AddEditPeriodDialog(),
    );
  }
}
