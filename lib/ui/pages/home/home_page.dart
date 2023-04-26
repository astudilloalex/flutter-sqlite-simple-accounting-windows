import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/ui/pages/account/account_page.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/add_seat_page.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_form_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/dashboard_page.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/detail/detail_page.dart';
import 'package:simple_accounting_offline/ui/pages/home/cubit/home_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/settings/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Available widgets for rail.
    final List<Widget> widgets = <Widget>[
      BlocProvider(
        create: (context) => DashboardCubit(),
        child: const DashboardPage(),
      ),
      BlocProvider(
        create: (context) => DetailCubit(),
        child: const DetailPage(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddSeatCubit(
              getIt<AccountingPeriodService>(),
            )..load(),
          ),
          BlocProvider(
            create: (context) => AddSeatFormCubit(),
          ),
        ],
        child: const AddSeatPage(),
      ),
      BlocProvider(
        create: (context) => AccountCubit(
          getIt<AccountService>(),
        )..loadAccounts(1),
        child: const AccountPage(),
      ),
      BlocProvider(
        create: (context) => SettingsCubit(
          getIt<AccountingPeriodService>(),
        )..load(),
        child: const SettingsPage(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80.0,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.read<HomeCubit>().changeExpandedRail();
              },
              icon: Icon(
                context.watch<HomeCubit>().state.extendedRail
                    ? Icons.menu_open_outlined
                    : Icons.menu_outlined,
              ),
            ),
          ],
        ),
        title: ElevatedButton.icon(
          onPressed: () {
            context.read<HomeCubit>().changeCurrentIndex(2);
          },
          label: Text(AppLocalizations.of(context)!.addMovement),
          icon: const Icon(Icons.add_outlined),
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: context.watch<HomeCubit>().state.extendedRail,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard_outlined),
                label: Text(AppLocalizations.of(context)!.dashboard),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.wallet_outlined),
                label: Text(AppLocalizations.of(context)!.details),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.add_circle_outlined),
                label: Text(AppLocalizations.of(context)!.add),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.account_balance_outlined),
                label: Text(AppLocalizations.of(context)!.accounts),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.settings_outlined),
                label: Text(AppLocalizations.of(context)!.settings),
              ),
            ],
            onDestinationSelected: (value) {
              context.read<HomeCubit>().changeCurrentIndex(value);
            },
            selectedIndex: context.watch<HomeCubit>().state.currentIndex,
            // labelType: context.watch<HomeCubit>().state.extendedRail
            //     ? null
            //     : NavigationRailLabelType.selected,
            minExtendedWidth: 200.0,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: widgets[context.watch<HomeCubit>().state.currentIndex],
          ),
        ],
      ),
    );
  }
}
