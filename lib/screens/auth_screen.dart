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
      appBar: AppBar(title: const Text("account")),
      body: provider.isLoggedIn
        ? Center(child: 
            Column(children: [
              Text(provider.id),
              FlatButton(
                child: const Text("Logout", style: TextStyle(color: Colors.red)),
                onPressed: () => provider.logout(),
              )
            ])
        )
        : AuthFormWrapper()
    );
  }
}
