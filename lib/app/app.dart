import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showErrorSnackbar(BuildContext context, String errorCode) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messageFromCode(errorCode, context)),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

String messageFromCode(String code, BuildContext context) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;
  final Map<String, String> errorMessages = {
    'user-not-found': localizations.userNotFound,
    'wrong-password': localizations.wrongPassword,
    'already-exists-period-in-the-year':
        localizations.alreadyExistsPeriodInTheYear,
  };
  return errorMessages[code] ?? code;
}
