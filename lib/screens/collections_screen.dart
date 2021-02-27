import 'dart:io';

import 'package:bartender/firebase_util.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/screens/shopping_list_screen.dart';
import 'package:bartender/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


class CollectionsScreen extends StatelessWidget {
  /**
   * TODO:
   *  1. when user is not logged in, show authForm instead of collections
   

  // var _isInit = false;
  // Future<dynamic> getUserInfo(currentUser, provider) async {
  //     final user = await getUserById(currentUser.uid);
  //     provider.setUser(
  //         id: currentUser.uid,
  //         name: user['username'],
  //         email: user['email'],
  //         collections: user['collections'],
  //         shopping: user['shopping']
  //     );
  //     return provider.collections;
  // }
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<User>(context);
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }
*/
  
  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) {
    print("auth form submitted ============");
    print(email);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);
    return Consumer<Auth>(
        builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(title: Text("Collections"), 
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => provider.logout(),
          )
        ]
      ),
      body: provider.isLoggedIn ? 
        ListView.separated(
          itemCount: provider.collections.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, idx) => ListTile(
            leading: Icon(IconData(provider.collections[idx]['icon'], fontFamily: 'MaterialIcons'), 
                      color: provider.collections[idx]['icon'] == 62607 ? Colors.yellow : Colors.pink),
            title: Text(provider.collections[idx]['name']),
            onTap: (){
              switch(provider.collections[idx]['name']){
                case "shopping":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShoppingListScreen()));
              }
            },
          )
        )
      : AuthForm(_submitAuthForm, false)
    ));
  }
}
// FutureBuilder<DocumentSnapshot>(
    //     future: users.doc(user.uid).get(),
    //     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Text("Loading");
    //       }
    //       final data = snapshot.data.data();
    //       if(!data.containsKey('collections')){
    //         return Center(child: const Text("You do not have any collections at the moment"),);
    //       } 
    //       final collections = data['collections'];