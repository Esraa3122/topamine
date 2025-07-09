import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/auth/presentation/refactors/rule_sign_up_body.dart';

class RuleSignUpScreen extends StatelessWidget {
  const RuleSignUpScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.color.mainColor,
        body: const RuleSignUpBody()
      ),
    );
  }
}
