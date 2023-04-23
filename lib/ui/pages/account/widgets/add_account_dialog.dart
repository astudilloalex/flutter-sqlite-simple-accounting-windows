import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/src/account_category/application/account_category_service.dart';
import 'package:simple_accounting_offline/src/account_category/domain/account_category.dart';
import 'package:simple_accounting_offline/src/account_type/application/account_type_service.dart';
import 'package:simple_accounting_offline/src/account_type/domain/account_type.dart';

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
  bool loading = true;

  final List<AccountType> accountTypes = [];
  final List<AccountCategory> accountCategories = [];
  int? selectedAccountTypeId;
  int? selectedAccountCategoryId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      accountTypes.addAll(await getIt<AccountTypeService>().getAll());
      accountCategories.addAll(await getIt<AccountCategoryService>().getAll());
    } finally {
      loading = false;
      setState(() {});
    }
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
                      selectedAccountTypeId = null;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(AppLocalizations.of(context)!.rootAccount),
                ),
                const SizedBox(height: 16.0),
                // Account type
                DropdownButtonFormField<int?>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: selectedAccountTypeId,
                  items: rootAccount
                      ? accountTypes
                          .where((element) => element.id == 1)
                          .map((type) {
                          return DropdownMenuItem<int?>(
                            value: type.id,
                            child: Text(type.name),
                          );
                        }).toList()
                      : accountTypes.map((type) {
                          return DropdownMenuItem<int?>(
                            value: type.id,
                            child: Text(type.name),
                          );
                        }).toList(),
                  decoration: InputDecoration(
                    labelText: loading
                        ? AppLocalizations.of(context)!.loading
                        : AppLocalizations.of(context)!.accountType,
                    hintText: AppLocalizations.of(context)!.select,
                  ),
                  focusColor: Colors.transparent,
                  onChanged: (value) {
                    setState(() {
                      selectedAccountTypeId = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                // Account Category
                DropdownButtonFormField<int?>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: selectedAccountCategoryId,
                  items: accountCategories.map((type) {
                    return DropdownMenuItem<int?>(
                      value: type.id,
                      child: Text(type.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: loading
                        ? AppLocalizations.of(context)!.loading
                        : AppLocalizations.of(context)!.accountCategory,
                    hintText: AppLocalizations.of(context)!.select,
                  ),
                  focusColor: Colors.transparent,
                  onChanged: (value) {
                    setState(() {
                      selectedAccountCategoryId = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                // Code input
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.code,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Name input
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
