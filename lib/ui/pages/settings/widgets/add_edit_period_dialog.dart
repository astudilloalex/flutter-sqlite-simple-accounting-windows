import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddEditPeriodDialog extends StatefulWidget {
  const AddEditPeriodDialog({super.key});

  @override
  State<AddEditPeriodDialog> createState() => _AddEditPeriodDialogState();
}

class _AddEditPeriodDialogState extends State<AddEditPeriodDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startDateController.text = DateFormat('MMMM dd, yyyy').format(
      DateTime(DateTime.now().year),
    );
    endDateController.text = DateFormat('MMMM dd, yyyy').format(
      DateTime(DateTime.now().year, 12, 31),
    );
  }

  @override
  void dispose() {
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
                  AppLocalizations.of(context)!.addPeriod,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const Divider(),
                // Name input
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.invalidName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: startDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.startDate,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.invalidDate;
                    }
                    final DateTime start = DateFormat('MMMM dd, yyyy').parse(
                      value,
                    );
                    final DateTime end = DateFormat('MMMM dd, yyyy').parse(
                      endDateController.text,
                    );
                    if (start.isAfter(end)) {
                      return AppLocalizations.of(context)!.invalidDate;
                    }
                    return null;
                  },
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ).then((value) {
                      if (value != null) {
                        startDateController.text = DateFormat(
                          'MMMM dd, yyyy',
                        ).format(
                          value,
                        );
                      }
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  controller: endDateController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.endDate,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.invalidDate;
                    }
                    final DateTime start = DateFormat('MMMM dd, yyyy').parse(
                      startDateController.text,
                    );
                    final DateTime end = DateFormat('MMMM dd, yyyy').parse(
                      value,
                    );
                    if (start.isAfter(end)) {
                      return AppLocalizations.of(context)!.invalidDate;
                    }
                    return null;
                  },
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ).then((value) {
                      if (value != null) {
                        endDateController.text = DateFormat(
                          'MMMM dd, yyyy',
                        ).format(
                          value,
                        );
                      }
                    });
                  },
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
                      onPressed: _save,
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

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
  }
}
