import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/ui/pages/splash/cubit/splash_cubit.dart';
import 'package:simple_accounting_offline/ui/routes/route_name.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator.adaptive(),
            Text(AppLocalizations.of(context)!.localeName),
          ],
        ),
      ),
    );
  }

  Future<void> _load() async {
    final bool isLogged = await context.read<SplashCubit>().authenticated();
    if (context.mounted) {
      if (isLogged) {
        context.go(RouteName.home);
      } else {
        context.go(RouteName.signIn);
      }
    }
  }
}
