import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/ui/pages/account/widgets/add_account_dialog.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AddAccountDialog(),
          );
        },
        label: Text(AppLocalizations.of(context)!.add),
        icon: const Icon(Icons.add_outlined),
      ),
    );
  }
}
