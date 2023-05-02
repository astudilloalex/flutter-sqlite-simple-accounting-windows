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
    'add-seat-details': localizations.addSeatDetails,
    'already-exists-period-in-the-year':
        localizations.alreadyExistsPeriodInTheYear,
    'select-a-period': localizations.selectAPeriod,
    'user-not-found': localizations.userNotFound,
    'username-already-exists': localizations.usernameAlreadyExists,
    'wrong-password': localizations.wrongPassword,
  };
  return errorMessages[code] ?? code;
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}
