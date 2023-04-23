import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/app/app.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/assets_account_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/account/widgets/add_account_dialog.dart';
import 'package:simple_accounting_offline/ui/pages/account/widgets/assets_tab_container.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: TabBar(
          isScrollable: true,
          onTap: context.read<AccountCubit>().onChangeTab,
          tabs: [
            Tab(
              icon: const Icon(Icons.money_outlined),
              text: AppLocalizations.of(context)!.assets.toUpperCase(),
            ),
            Tab(
              icon: const Icon(Icons.line_axis_outlined),
              text: AppLocalizations.of(context)!.liabilities.toUpperCase(),
            ),
            Tab(
              icon: const Icon(Icons.home_outlined),
              text: AppLocalizations.of(context)!.patrimony.toUpperCase(),
            ),
            Tab(
              icon: const Icon(Icons.monetization_on_outlined),
              text: AppLocalizations.of(context)!.incomes.toUpperCase(),
            ),
            Tab(
              icon: const Icon(Icons.money_off_outlined),
              text: AppLocalizations.of(context)!.expenses.toUpperCase(),
            ),
            Tab(
              icon: const Icon(Icons.keyboard_option_key_sharp),
              text: AppLocalizations.of(context)!
                  .otherComprehensiveIncome
                  .toUpperCase(),
            ),
          ],
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const AssetsTabContainer(),
            Icon(Icons.abc_outlined),
            Icon(Icons.abc_outlined),
            Icon(Icons.abc_outlined),
            Icon(Icons.abc_outlined),
            Icon(Icons.abc_outlined),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog<Account?>(
              context: context,
              barrierDismissible: false,
              builder: (_) => AddAccountDialog(
                categoryId: context.read<AccountCubit>().state.currentTab + 1,
              ),
            ).then((value) {
              _onAdd(value, context);
            });
          },
          label: Text(AppLocalizations.of(context)!.add),
          icon: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }

  Future<void> _onAdd(Account? account, BuildContext context) async {
    if (account == null) return;
    final String? error =
        await context.read<AccountCubit>().saveAccount(account);
    if (context.mounted) {
      if (error != null) {
        showErrorSnackbar(context, error);
      } else {
        switch (context.read<AccountCubit>().state.currentTab) {
          case 0:
            context.read<AssetsAccountCubit>().load();
            break;
        }
      }
    }
  }
}
