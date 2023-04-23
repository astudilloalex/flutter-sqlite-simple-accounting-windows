import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({super.key});

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool rootAccount = false;

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450.0),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                // Title
                Text(
                  AppLocalizations.of(context)!.addAccount,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const Divider(),
                // If root account
                CheckboxListTile(
                  value: rootAccount,
                  onChanged: (value) {
                    setState(() {
                      rootAccount = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(AppLocalizations.of(context)!.rootAccount),
                ),
                const SizedBox(height: 16.0),
                // Code input
                TextFormField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.code,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Name input
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.cancel_outlined),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      label: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.save_outlined),
                      label: Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
