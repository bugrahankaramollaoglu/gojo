import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gojo/riverpod_providers.dart';

class SignInForm extends ConsumerWidget {
  SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Center(
      child: ElevatedButton(
        child: Text('go back from signin formmm'),
        onPressed: () {
          ref.read(showEmailForm.notifier).state = !ref.read(showEmailForm);
        },
      ),
    ));
  }
}
