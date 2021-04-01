import 'dart:io';
import 'package:bartender/firebase_util.dart';
import 'package:bartender/model/cocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

class Auth with ChangeNotifier{
  String id;
  String username;
  String email;
  String location;
  String imageUrl;
  ImageProvider profileImage;
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference collection = FirebaseFirestore.instance.collection('users');
  List<dynamic> _collections;
  List<String> _custom;
  List<String> _shoppingList;
  List<String> _favorites;

  Set<String> _mybarIngredients;
  Set<String> _mybarCocktails = new Set<String>();
  Map<String, List<String>> _missing1Ing = new Map<String, List<String>>();

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
        profileImage = userData['imageUrl'] == '' 
          ? AssetImage('images/bartender-avatar.png') 
          : NetworkImage(userData['imageUrl']);
        _collections = userData['collections'];
        _custom = userData['custom'].cast<String>();
        _shoppingList = userData['shopping'].cast<String>();
        _favorites = userData['favorites'].cast<String>();
        List<String> ingredientsData = userData['bar']['ingredients'].cast<String>();
        // List<String> cocktailsData = userData['bar']['cocktails'].cast<String>();
        _mybarIngredients = ingredientsData.toSet();
        // _mybarCocktails = cocktailsData.toSet();
        // print("resetted userDoc in authInit");
        notifyListeners();
      }
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
        _custom = userData['custom'].cast<String>();
        _shoppingList = userData['shopping'].cast<String>();
        _favorites = userData['favorites'].cast<String>();
        List<String> ingredientsData = userData['bar']['ingredients'].cast<String>();
        // final cocktailsData = userData['bar']['cocktails'].cast<String>();
        _mybarIngredients = ingredientsData.toSet();
        profileImage = userData['imageUrl'] == '' 
          ? AssetImage('images/bartender-avatar.png') 
          : NetworkImage(userData['imageUrl']);
        // _mybarCocktails = cocktailsData.toSet();
      }
      notifyListeners();
    } catch (err) {
      print(err);
      throw(err);
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
        String url = await saveImageToFireStore(image, 'user_image', id);
        await setEmptyUser(id, email, username, location, url);
      } else {
        await setEmptyUser(id, email, username, location, null);
      }
      login(email, password);

      notifyListeners();
    } catch(e){
      print(e.message);
      throw(e);
    }
  }

  Future<void> logout() async {
    if(isLoggedIn){
      await FirebaseAuth.instance.signOut();
      currentUser = null;
      id = null;
      _collections = [];
      _custom = [];
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
  List<String> get custom => [..._custom];
  List<String> get mybarCocktails { return [..._mybarCocktails]; }
  List<String> get mybarIngredients { return [..._mybarIngredients]; }
  Map<String, List<String>> get missing1Ing {return {..._missing1Ing}; }

  bool inShoppingList(String ingId){
    return _shoppingList.contains(ingId);
  }

  List<dynamic> get collections {
    return [..._collections];
  }

  void addShoppingListItem(String ing) async {
    if(!_shoppingList.contains(ing)){
      _shoppingList.add(ing);
      notifyListeners();
      await collection.doc(currentUser.uid).update({'shopping': FieldValue.arrayUnion([ing])});
    }
  }

  void removeShoppingListItem(String ing) async {
    if(_shoppingList.contains(ing)){
      int index = _shoppingList.indexOf(ing);
      _shoppingList.removeAt(index);
      notifyListeners();
      await collection.doc(currentUser.uid).update({'shopping': FieldValue.arrayRemove([ing])});
    }
  }

  Future<void> updateShoppingList(List<String> newList) async {
    // List<String> concatList = newList + _shoppingList;
    // List<String> distinctList = [...{..._shoppingList}];
    _shoppingList = [...{...newList}];
    notifyListeners();
    await collection.doc(currentUser.uid).update({'shopping': _shoppingList});
  }

  void addFavorites(String cocktailId) async {
    if(!_favorites.contains(cocktailId)){
      _favorites.add(cocktailId);
      notifyListeners();
      await collection.doc(currentUser.uid).update({'favorites': FieldValue.arrayUnion([cocktailId])});
    }
  }

  void removeFavorites(String cocktailId) async {
    if(_favorites.contains(cocktailId)){
      int index = _favorites.indexOf(cocktailId);
      _favorites.removeAt(index);
      notifyListeners();
      await collection.doc(currentUser.uid).update({'favorites': FieldValue.arrayRemove([cocktailId])});
    }
  }

  void addCustom(String communityCocktailId) async{
    if(!_custom.contains(communityCocktailId)){
      _custom.add(communityCocktailId);
      notifyListeners();
      await collection.doc(currentUser.uid).update({'custom': FieldValue.arrayUnion([communityCocktailId])});
    }
  }
  void removeCustom(String communityCocktailId) async{
    if(_custom.contains(communityCocktailId)){
      int index = _custom.indexOf(communityCocktailId);
      _custom.removeAt(index);
      notifyListeners();
      await collection.doc(currentUser.uid).update({'custom': FieldValue.arrayRemove([communityCocktailId])});
    }
  }

  void initMybarCocktails(){
    Tuple2<Set<String>, Map<String, List<String>>> results = calculateCocktails(_mybarIngredients, _missing1Ing, _mybarCocktails,);
    _mybarCocktails = results.item1;
    _missing1Ing = results.item2;
  }

  Future<void> addIngredientToMyBar(String id) async {
    _mybarIngredients.add(id);
    await collection.doc(currentUser.uid).update({'bar.ingredients': FieldValue.arrayUnion([id])});
    if(_missing1Ing.containsKey(id)){
      _mybarCocktails.addAll(_missing1Ing[id]);
      _missing1Ing.remove(id);
      notifyListeners();
      return;
    }
    Tuple2<Set<String>, Map<String, List<String>>> results = calculateCocktails(_mybarIngredients, _missing1Ing, _mybarCocktails);
    _mybarCocktails = results.item1;
    _missing1Ing = results.item2;
    notifyListeners();
    return;
  }
  Future<void> removeIngredientFromMyBar(String ingId) async{
    _mybarIngredients.remove(ingId);
    await collection.doc(currentUser.uid).update({'bar.ingredients': FieldValue.arrayRemove([ingId])});
    List<String> toRemove = [];
    for (String cocktailId in _mybarCocktails){
      Cocktail cocktail = findCocktailById(cocktailId);
      if(cocktail.ingredientsIds.contains(ingId)){
        toRemove.add(cocktailId);
      }
    }
    _mybarCocktails.removeAll(toRemove);
    _missing1Ing[ingId] = toRemove;
    return;
  }

}