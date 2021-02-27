import 'dart:io';
import 'package:bartender/model/ingredient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier{
  // String name;
  // String email;
  String id;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference collection = FirebaseFirestore.instance.collection('users');
  List<dynamic> _collections;
  List<dynamic> _shoppingList;
  List<dynamic> _mybarIngredients;

  get isLoggedIn {
    return currentUser != null;
  }

  Future<void> signup(String username, String email, String password, File image ) async {
    UserCredential authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    currentUser = authResult.user;
    id = authResult.user.uid;
    if (image != null){
      final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child(authResult.user.uid + '.jpg');

      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      await setEmptyUser(id, email, username, url);
    } else {
      await setEmptyUser(id, email, username, null);
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    currentUser = authResult.user;
    id = authResult.user.uid;
    DocumentSnapshot userDoc = await collection.doc(id).get();
    if(userDoc.exists){
      final userData = userDoc.data();
      _collections = userData['collections'];
      _shoppingList = userData['shopping'];
      _mybarIngredients = userData['bar']['ingredients'];
    }
    notifyListeners();
  }

  Future<void> logout() async {
    if(isLoggedIn){
      await FirebaseAuth.instance.signOut();
      currentUser = null;
      id = null;
      notifyListeners();
    }
  }

  Future<DocumentReference> setEmptyUser(String id, String email, String username, String url) async {
    DocumentReference userDoc = collection.doc(id);
    
    _collections = [
      {
        "name": "custom",
        "icon": 59430
      }, 
      {
        "name": "shopping",
        "icon": 58389
      },
      {
        "name": "favorites",
        "icon": 62607
      },
    ];
    _shoppingList = [];
    _mybarIngredients = [];
    await userDoc.set({
      'username': username,
      'email': email,
      'imageUrl': url == null ? "" : url,
      'collections': _collections,
      'shopping': _shoppingList,
      'favorites': [],
      'custom': [],
      'bar': {
        'ingredients': _mybarIngredients,
        'cocktails': [],
      }
    });
    return userDoc;
  }

  List<dynamic> get shoppingList {
    return [..._shoppingList];
  }

  List<dynamic> get mybarIngredients {
    return [..._mybarIngredients];
  }

  List<dynamic> get collections {
    return [..._collections];
  }

  void addShoppingListItem(String ing){
    _shoppingList.add(ing);
    notifyListeners();
  }

  void removeShoppingListItem(String ing){
    int index = _shoppingList.indexOf(ing);
    _shoppingList.removeAt(index);
    notifyListeners();
  }

  void addIngredientToMyBar(String id){
    _mybarIngredients.add(id);
    notifyListeners();
  }
  void removeIngredientFromMyBar(String id){
    int index = _mybarIngredients.indexOf(id);
    _mybarIngredients.removeAt(index);
    notifyListeners();
  }

}