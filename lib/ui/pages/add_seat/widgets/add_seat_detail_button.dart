import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_detail_dialog.dart';

class AddSeatDetailButton extends StatelessWidget {
  const AddSeatDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return const AddSeatDetailDialog();
              },
            );
          },
          label: Text(AppLocalizations.of(context)!.add),
          icon: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }
}
