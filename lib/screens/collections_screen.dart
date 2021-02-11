import 'package:bartender/screens/gridview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CollectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final collections = FirebaseFirestore.instance.collection('users').doc("FTNuvRC3FSfjN9aH4kbn").collection("collections");

    return Scaffold(
      appBar: AppBar(title: Text("Collections")),
      body: StreamBuilder(
        stream: collections.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return new ListView(
            children: ListTile.divideTiles(
              context: context, 
              tiles: snapshot.data.docs.map((DocumentSnapshot collection) => ListTile(
                leading: Icon(IconData(collection['icon'], fontFamily: 'MaterialIcons'), 
                      color: collection['icon'] == 62607 ? Colors.yellow : Colors.pink),
                title: Text(collection['name']),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_){
                      return GridViewScreen(collection);
                    }
                  )
                ),
              )), 
            ).toList(),
          );
      }),
    );
  }
}