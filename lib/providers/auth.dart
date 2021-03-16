import 'dart:io';
import 'package:bartender/firebase_util.dart';
import 'package:bartender/model/cocktail.dart';
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
  List<String> _custom;
  List<String> _shoppingList;
  List<String> _favorites;

  Set<String> _mybarIngredients;
  Set<String> _mybarCocktails;
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
        imageUrl = userData['imageUrl'] == '' ? null : userData['imageUrl'];
        _collections = userData['collections'];
        _custom = userData['custom'].cast<String>();
        _shoppingList = userData['shopping'].cast<String>();
        _favorites = userData['favorites'].cast<String>();
        List<String> ingredientsData = userData['bar']['ingredients'].cast<String>();
        final cocktailsData = userData['bar']['cocktails'].cast<String>();
        _mybarIngredients = ingredientsData.toSet();
        _mybarCocktails = cocktailsData.toSet();
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
        _custom = userData['custom'].cast<String>();
        _shoppingList = userData['shopping'].cast<String>();
        _favorites = userData['favorites'].cast<String>();
        List<String> ingredientsData = userData['bar']['ingredients'].cast<String>();
        final cocktailsData = userData['bar']['cocktails'].cast<String>();
        _mybarIngredients = ingredientsData.toSet();
        _mybarCocktails = cocktailsData.toSet();
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

  void addIngredientToMyBar(String id){
    _mybarIngredients.add(id);
    if(_missing1Ing.containsKey(id)){
      _mybarCocktails.addAll(_missing1Ing[id]);
      _missing1Ing.remove(id);
      notifyListeners();
      return;
    }
    for(Cocktail cocktail in allCocktails){
      // check if added ingredient is in missing1Ing
      if(!_mybarCocktails.contains(cocktail.id)){
        final common = _mybarIngredients.intersection(cocktail.ingredientsIds);
        if(common.length == cocktail.ingredientsIds.length){
          _mybarCocktails.add(cocktail.id);
        } else if(common.length == cocktail.ingredientsIds.length - 1){
          String missingIng = cocktail.ingredientsIds.difference(common).first;
          if(_missing1Ing.containsKey(missingIng) && !_missing1Ing[missingIng].contains(cocktail.id)){
            _missing1Ing[missingIng].add(cocktail.id);
          } else{
            _missing1Ing[missingIng] = <String>[cocktail.id];
          }
        }
      }
    }
    notifyListeners();
    // add to firebase
    return;
  }
  void removeIngredientFromMyBar(String id){
    // remove from firebase
  }

}