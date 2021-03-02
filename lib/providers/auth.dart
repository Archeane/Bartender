import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Auth with ChangeNotifier{
  String id;
  String username;
  String email;
  String location;
  String imageUrl;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference collection = FirebaseFirestore.instance.collection('users');
  List<dynamic> _collections;
  List<String> _shoppingList;
  List<String> _favorites;

  get isLoggedIn {
    return currentUser != null && _collections != null && _shoppingList != null;
  }

  Future<void> authInit() async {
    if (currentUser != null && _collections == null){
      DocumentSnapshot userDoc = await collection.doc(currentUser.uid).get();
      if(userDoc.exists){
        final userData = userDoc.data();
        id = currentUser.uid;
        username = userData['username'];
        email = userData['email'];
        location = userData['location'] == '' ? null : userData['location'];
        imageUrl = userData['imageUrl'] == '' ? null : userData['imageUrl'];
        _collections = userData['collections'];
        _shoppingList = userData['shopping'].cast<String>();
        _favorites = userData['favorites'].cast<String>();
        print("resetted userDoc in authInit");
        notifyListeners();
      }
    }
  }

  Future<void> signup(String username, String email, String password, String location, File image ) async {
    try {
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
        await setEmptyUser(id, email, username, location, url);
      } else {
        await setEmptyUser(id, email, username, location, null);
      }

      notifyListeners();
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      throw(message);
    } catch (err) {
      print(err);
      throw("An error occured in the server, please try again later!");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser = authResult.user;
      id = authResult.user.uid;
      DocumentSnapshot userDoc = await collection.doc(id).get();
      if(userDoc.exists){
        final userData = userDoc.data();
        username = userData['username'];
        email = userData['email'];
        location = userData['location'] == '' ? null : userData['location'];
        imageUrl = userData['imageUrl'] == '' ? null : userData['imageUrl'];
        _collections = userData['collections'];
        _shoppingList = userData['shopping'].cast<String>();
        _favorites = userData['favorites'].cast<String>();
        
      }
      notifyListeners();
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      throw(message);
    } catch (err) {
      print(err);
      throw("An error occured in the server, please try again later!");
    }
  }

  Future<void> logout() async {
    print(isLoggedIn);
    if(isLoggedIn){
      await FirebaseAuth.instance.signOut();
      currentUser = null;
      id = null;
      _collections = [];
      _shoppingList = [];
      _favorites = [];
      notifyListeners();
    }
  }

  Future<DocumentReference> setEmptyUser(String id, String email, String username, String location, String url) async {
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
    await userDoc.set({
      'username': username,
      'email': email,
      'imageUrl': url == null ? "" : url,
      'location': location,
      'collections': _collections,
      'shopping': [],
      'favorites': [],
      'custom': [],
      'bar': {
        'ingredients': [],
        'cocktails': [],
      }
    });
    return userDoc;
  }

  List<String> get shoppingList {
    return [..._shoppingList];
  }
  List<String> get favorites {
    return [..._favorites];
  }

  Future<List<String>> get mybarIngredients async {
    if (currentUser != null){
      DocumentSnapshot userDoc = await collection.doc(currentUser.uid).get();
      if(userDoc.exists){
        final userData = userDoc.data();
        return userData['bar']['ingredients'].cast<String>();
      }
    }
    return null;
  }

  List<dynamic> get collections {
    return [..._collections];
  }

  void addShoppingListItem(String ing){
    if(!_shoppingList.contains(ing)){
      // add to firebase
      _shoppingList.add(ing);
      notifyListeners();
    }
  }

  void removeShoppingListItem(String ing){
    if(_shoppingList.contains(ing)){
      int index = _shoppingList.indexOf(ing);
      _shoppingList.removeAt(index);
      notifyListeners();
    }
  }

  void updateShoppingList(List<String> newList){
    _shoppingList = newList;
    print(_shoppingList);
    notifyListeners();
  }

  void addFavorites(String cocktailId){
    if(!_favorites.contains(cocktailId)){
      _favorites.add(cocktailId);
      notifyListeners();
    }
  }

  void removeFavorites(String cocktailId){
    if(_favorites.contains(cocktailId)){
      int index = _favorites.indexOf(cocktailId);
      _favorites.removeAt(index);
      notifyListeners();
    }
  }

  void addIngredientToMyBar(String id){
    // add to firebase
  }
  void removeIngredientFromMyBar(String id){
    // remove from firebase
  }

}