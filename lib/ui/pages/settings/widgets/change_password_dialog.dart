import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  bool viewPassword = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.changePassword} -> ${widget.user.username}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const Divider(height: 20.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.newPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => viewPassword = !viewPassword);
                      },
                      icon: Icon(
                        viewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return AppLocalizations.of(context)!.min6Characters;
                    }
                    return null;
                  },
                  obscureText: !viewPassword,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        context.pop(passwordController.text.trim());
                      },
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
