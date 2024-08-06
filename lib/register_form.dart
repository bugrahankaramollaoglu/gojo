import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gojo/riverpod_providers.dart';

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Center(
      child: ElevatedButton(
        child: Text('go back from register'),
        onPressed: () {
          ref.read(showRegisterForm.notifier).state =
              !ref.read(showRegisterForm);
        },
      ),
    ));
  }
}
