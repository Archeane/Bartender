
import 'dart:io';

import 'package:bartender/model/cocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tuple/tuple.dart';

import './model/ingredient.dart';


class InvalidArgumentException implements Exception {
  String error;
  InvalidArgumentException(this.error);
}

bool isInit = false;
CollectionReference ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
CollectionReference cocktailsCollection = FirebaseFirestore.instance.collection('cocktails');
CollectionReference communityCollection = FirebaseFirestore.instance.collection('community');
CollectionReference userCollection = FirebaseFirestore.instance.collection('community');

List<Ingredient> allIngredients;
List<Cocktail> allCocktails;

// Map<String, List<Ingredient>> allIngredientsByType = new Map<String, List<Ingredient>>();

Future<void> init() async {
  if(!isInit){
    allIngredients = await fetchAllIngredients();
    allCocktails = await fetchAllCocktails();

    // allIngredientsByType['spirit'] = allIngredients.where((ing) => ing.type != null && ing.type.toLowerCase() == "spirit");
    // allIngredientsByType['liqueur'] = allIngredients.where((ing) => ing.type != null && ing.type.toLowerCase() == "liqueur");
    
    print("loaded allingredients and all cocktails in init()");
    isInit = true;
    return;
  }
  print("is init if false in firebase_util");
  return;
}

Future<Map<String, dynamic>> getUserById(String id) async {
  DocumentSnapshot snapshot = await userCollection.doc(id).get();
  if(snapshot.exists){
    return snapshot.data();
  }
  return null;
}

Ingredient getIngredientById(String id) {
  if(allIngredients != null){
    int idx = allIngredients.indexWhere((ing) => ing.id == id);
    if(idx != -1){
      return allIngredients[idx];
    }
  }
  return null;
}

Future<Ingredient> fetchIngredientById(String id) async {
  DocumentSnapshot snapshot = await ingredientsCollection.doc(id).get();
  if (snapshot.exists) {
    final data = snapshot.data();
    var temp = Ingredient(
      id: id,
      name: data['name']
    );
    return temp;
  }
  throw new InvalidArgumentException("$id does not exist");
}

Future<List<Ingredient>> fetchAllIngredients() async {
  List<Ingredient> ingredients = new List<Ingredient>();
  QuerySnapshot snapshot = await ingredientsCollection.get();
  for(var doc in snapshot.docs){
      ingredients.add(Ingredient.fromFirebaseSnapshot(doc.id, doc.data()));
  }
  ingredients.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return ingredients;
}

Future<List<Cocktail>> fetchAllCocktails() async {
  List<Cocktail> cocktails = <Cocktail>[];
  QuerySnapshot snapshot = await cocktailsCollection.get();
  for(QueryDocumentSnapshot doc in snapshot.docs){
    cocktails.add(Cocktail.fromFirebaseSnapshot(doc.id, doc.data()));
  }
  return cocktails;
}

List<Cocktail> findCocktailsByIds(List<String> ids) {
  List<Cocktail> data = <Cocktail>[];
  for (String id in ids){
    int index = allCocktails.indexWhere((doc) => doc.id == id);
    if(index >= 0){
      data.add(allCocktails[index]);
    }
  }
  return data;
}

Cocktail findCocktailById(String id) {
  int index = allCocktails.indexWhere((doc) => doc.id == id);
  if(index >= 0){
    return allCocktails[index];
  }
  return null;
}

Future<List<CommunityCocktail>> fetchAllCommunityCocktail() async {
  List<CommunityCocktail> data = <CommunityCocktail>[];
  QuerySnapshot snapshot = await communityCollection.get();
  for(QueryDocumentSnapshot doc in snapshot.docs){
    data.add(CommunityCocktail.fromFirebaseSnapshot(doc.id, doc.data()));
  }
  return data;
}

Future<CommunityCocktail> findCommunityCocktailById(String id) async {
  DocumentSnapshot snapshot = await communityCollection.doc(id).get();
  return CommunityCocktail.fromFirebaseSnapshot(id, snapshot.data());
}

Future<List<CommunityCocktail>> findCommunityCocktailByIds(List<String> ids) async {
  
  List<CommunityCocktail> allCommunityCocktails = await fetchAllCommunityCocktail();
  List<CommunityCocktail> data = <CommunityCocktail>[];
  for (String id in ids){
    int index = allCommunityCocktails.indexWhere((doc) => doc.id == id);
    if(index >= 0){
      data.add(allCommunityCocktails[index]);
    }
  }
  return data;
}

Future<String> saveCommunityCocktail(Map<String, dynamic> cocktailData) async {
    DocumentReference doc = await communityCollection.add(cocktailData);
    return doc.id;
}

Tuple2<Set<String>, Map<String, List<String>>> calculateCocktails(
    Set<String> ingredients, 
    Map<String, List<String>> missing1Ing, 
    Set<String> cocktails
  ){
  if(ingredients.length == 0)
    return Tuple2<Set<String>, Map<String, List<String>>>({}, {});
  for(Cocktail cocktail in allCocktails){
      // check if added ingredient is in missing1Ing
      if(!cocktails.contains(cocktail.id)){
        final common = ingredients.intersection(cocktail.ingredientsIds);
        if(common.length == cocktail.ingredientsIds.length){
          cocktails.add(cocktail.id);
          // await collection.doc(currentUser.uid).update({'bar.cocktails': FieldValue.arrayUnion([cocktail.id])});
        } else if(common.length == cocktail.ingredientsIds.length - 1){
          String missingIng = cocktail.ingredientsIds.difference(common).first;
          if(missing1Ing.containsKey(missingIng) && !missing1Ing[missingIng].contains(cocktail.id)){
            missing1Ing[missingIng].add(cocktail.id);
          } else{
            missing1Ing[missingIng] = <String>[cocktail.id];
          }
        }
      }
    }
  return Tuple2<Set<String>, Map<String, List<String>>>(cocktails, missing1Ing);
}

Future<String> saveImageToFireStore(File image, String collection, String id) async{
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
    .ref()
    .child(collection)
    .child(id+'.jpg');

  await ref.putFile(image);
  final url = await ref.getDownloadURL();
  return url;
}