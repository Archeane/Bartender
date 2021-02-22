import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bartender/screens/collection_grid_screen.dart';

class CollectionsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    final users = FirebaseFirestore.instance.collection('users'); 
    return Scaffold(
      appBar: AppBar(title: Text("Collections")),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          final data = snapshot.data.data();
          if(!data.containsKey('collections')){
            return Center(child: const Text("You do not have any collections at the moment"),);
          } 
          final collections = data['collections'];
          return ListView.separated(
            itemCount: collections.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) => ListTile(
              leading: Icon(IconData(collections[idx]['icon'], fontFamily: 'MaterialIcons'), 
                        color: collections[idx]['icon'] == 62607 ? Colors.yellow : Colors.pink),
              title: Text(collections[idx]['name']),
              onTap: (){

              },
            )
          );
        }
      )
    );
  }
}
