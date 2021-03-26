
import 'package:bartender/model/cocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './model/ingredient.dart';


class InvalidArgumentException implements Exception {
  String error;
  InvalidArgumentException(this.error);
}

bool isInit = false;
CollectionReference ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
CollectionReference cocktailsCollection = FirebaseFirestore.instance.collection('cocktails');
CollectionReference communityCollection = FirebaseFirestore.instance.collection('community');
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
    print(allIngredients);
    print(allCocktails);
    isInit = true;
    return;
  }
  print("is init if false in firebase_util");
  return;
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

Future<List<CommunityCocktail>> fetchAllCommunityCocktail() async {
  List<CommunityCocktail> data = <CommunityCocktail>[];
  QuerySnapshot snapshot = await communityCollection.get();
  for(QueryDocumentSnapshot doc in snapshot.docs){
    data.add(CommunityCocktail.fromFirebaseSnapshot(doc.id, doc.data()));
  }
  return data;
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


// // =============== User related actions =====================

// Future<void> addIngredientToMyBar(String ingredientId) async {
//   DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
//   if(userSnapshot.exists){
//     final ingredients = userSnapshot.data()['bar']['ingredients'];
//     ingredients.add(ingredientId);
//     await usersCollection.doc(user.uid)
//           .update({'bar.ingredients': ingredients});
//   }
// }

// Future<void> removeIngredientFromMyBar(String ingredientId) async {
//   DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
//   if(userSnapshot.exists){
//     final ingredients = userSnapshot.data()['bar']['ingredients'];
//     int index = ingredients.indexOf(ingredientId);
//     ingredients.removeAt(index);
//     await usersCollection.doc(user.uid)
//           .update({'bar.ingredients': ingredients});
//   }
// }

// Future<void> addShoppingListItem(String ingredientId) async {
//   Auth authProvider = Provider.of<Auth>(context, listen:false);
// .collection('YourCollection')
// .document('YourDocument')
// .updateData({'array':FieldValue.arrayUnion(['data1','data2','data3'])});
//   DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
//   if(userSnapshot.exists){
//     final ingredients = userSnapshot.data()['bar']['ingredients'];
//     ingredients.add(ingredientId);
//     await usersCollection.doc(user.uid)
//           .update({'bar.ingredients': ingredients});
//   }
// }
