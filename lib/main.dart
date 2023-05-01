import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/ui/routes/route_page.dart';
import 'package:simple_accounting_offline/ui/theme/app_theme_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setUpData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: RoutePage.router,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppThemeData.light,
    );
  }
}

Future<void> _setUpData() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  await GetStorage.init();
  setUpGetIt();
}
