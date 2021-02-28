import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context); 
    return Scaffold(
      body: provider.isLoggedIn
        ? Center(child: Text(provider.id))
        : AuthFormWrapper()
    );
  }
}
