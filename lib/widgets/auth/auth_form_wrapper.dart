import 'dart:io';

import 'package:bartender/screens/auth_screen.dart';
import 'package:bartender/widgets/auth/auth_form.dart';
import 'package:bartender/providers/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthFormWrapper extends StatefulWidget {
  final bool showScaffold;
  
  AuthFormWrapper({this.showScaffold = false});

  @override
  _AuthFormWrapperState createState() => _AuthFormWrapperState();
}

class _AuthFormWrapperState extends State<AuthFormWrapper> {

  bool _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    String location,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() => _isLoading = true);
      final provider = Provider.of<Auth>(context, listen: false);
      if (isLogin) {
        await provider.login(email, password);
      } else {
        await provider.signup(username, email, password, location, image);
      }      
      setState(() => _isLoading = false);
    } catch (err) {
      setState(() => _isLoading = false);
      //debugPrint(err);
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context); 
    return _isLoading 
    ? Center(child: CircularProgressIndicator())
    : FutureBuilder(
        future: provider.authInit(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(!provider.isLoggedIn){
            if (!widget.showScaffold){
              return AuthForm(_submitAuthForm, false);
            }
            return Scaffold(
              appBar: AppBar(title: const Text("Login/Signup"),),
              body: AuthForm(_submitAuthForm, false)
            );
          }
          return AuthScreen();
        }
      );
  }
}