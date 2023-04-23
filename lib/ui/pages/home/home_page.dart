import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/ui/pages/account/account_page.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/dashboard_page.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/detail/detail_page.dart';
import 'package:simple_accounting_offline/ui/pages/home/cubit/home_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/report/cubit/report_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/report/report_page.dart';

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
      BlocProvider(
        create: (context) => AccountCubit(),
        child: const AccountPage(),
      ),
      BlocProvider(
        create: (context) => ReportCubit(),
        child: const ReportPage(),
      ),
    ];
    return Scaffold(
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
                icon: const Icon(Icons.account_balance_outlined),
                label: Text(AppLocalizations.of(context)!.accounts),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.report_outlined),
                label: Text(AppLocalizations.of(context)!.reports),
              ),
            ],
            onDestinationSelected: (value) {
              context.read<HomeCubit>().changeCurrentIndex(value);
            },
            selectedIndex: context.watch<HomeCubit>().state.currentIndex,
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().changeExpandedRail();
                  },
                  icon: Icon(
                    context.watch<HomeCubit>().state.extendedRail
                        ? Icons.arrow_back_ios_new_outlined
                        : Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ),
            ),
            labelType: context.watch<HomeCubit>().state.extendedRail
                ? null
                : NavigationRailLabelType.selected,
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
