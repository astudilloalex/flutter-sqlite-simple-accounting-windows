import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/app/app.dart';
import 'package:simple_accounting_offline/ui/pages/sign_in/cubit/sign_in_cubit.dart';
import 'package:simple_accounting_offline/ui/routes/route_name.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Username input
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.username,
              prefixIcon: const Icon(Icons.person_outlined),
            ),
          ),
          const SizedBox(height: 20.0),
          // Password input
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.password,
              prefixIcon: const Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  context.watch<SignInCubit>().state.viewPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  context.read<SignInCubit>().changePasswordVisibility();
                },
              ),
            ),
            obscureText: !context.watch<SignInCubit>().state.viewPassword,
          ),
          const SizedBox(height: 10.0),
          CheckboxListTile(
            value: context.read<SignInCubit>().state.remember,
            onChanged: (value) {
              context.read<SignInCubit>().changeRemember();
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(AppLocalizations.of(context)!.remember),
          ),
          const SizedBox(height: 10.0),
          // Login button.
          ElevatedButton.icon(
            onPressed:
                context.watch<SignInCubit>().state.loading ? null : _signIn,
            icon: context.watch<SignInCubit>().state.loading
                ? const SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator.adaptive(),
                  )
                : const Icon(Icons.login_outlined),
            label: Text(AppLocalizations.of(context)!.signIn),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn() async {
    final String? error = await context.read<SignInCubit>().signIn(
          usernameController.text,
          passwordController.text,
        );
    if (context.mounted) {
      if (error == null) {
        context.goNamed(RouteName.home);
      } else {
        showErrorSnackbar(context, error);
      }
    }
  }
}
