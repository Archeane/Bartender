import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSingleton {
  static final UserSingleton _singleton = UserSingleton._internal();

  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users'); 
  User currentLoggedInUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot currentUserSnapshot;
  bool isLoggedIn = false;

  factory UserSingleton(){
    return _singleton;
  }

  void init() async {
    currentUserSnapshot = await usersCollection.doc(currentLoggedInUser.uid).get();
    isLoggedIn = currentLoggedInUser != null;
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    DocumentSnapshot userSnapshot = await usersCollection.doc(id).get();
    if(userSnapshot.exists){
      return userSnapshot.data();
    }
  }

  UserSingleton._internal();
}








