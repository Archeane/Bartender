
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

// Future<List<Ingredient>> fetchUserShoppingList() async {
//   List<Ingredient> ingredients = new List<Ingredient>();
//   DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
//   if(userSnapshot.exists){
//     final userData = userSnapshot.data();
//     for(var ingredientId in userData['shopping']){
//       Ingredient doc = await fetchIngredientById(ingredientId);
//       ingredients.add(doc);
//     }
//   }
//   return ingredients;
// }

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

// Future<List<Ingredient>> fetchMybarIngredients() async {
//   List<Ingredient> ingredients = new List<Ingredient>();
//   DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
//   if(userSnapshot.exists){
//     final userData = userSnapshot.data();
//     for(var ingredientId in userData['bar']['ingredients']){
//       print(ingredientId);
//       Ingredient doc = await fetchIngredientById(ingredientId);
//       ingredients.add(doc);
//     }
//   }
//   return ingredients;
//  }

// Future<List<dynamic>> getMyBarIngredients() async {
//   CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
//   DocumentSnapshot userSnapshot = await usersCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
//   if(userSnapshot.exists){
//     return userSnapshot.data()['bar']['ingredients'];
//   }
//   return null;
// }

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
  List<Cocktail> cocktails = new List<Cocktail>();
  QuerySnapshot snapshot = await cocktailsCollection.get();
  for(QueryDocumentSnapshot doc in snapshot.docs){
    cocktails.add(Cocktail.fromFirebaseSnapshot(doc.id, doc.data()));
  }
  return cocktails;
}

List<Cocktail> findCocktailsByIds(List<String> ids) {
  List<Cocktail> data = new List<Cocktail>();
  for (String id in ids){
    int index = allCocktails.indexWhere((doc) => doc.id == id);
    data.add(allCocktails[index]);
  }
  return data;
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
//   DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
//   if(userSnapshot.exists){
//     final ingredients = userSnapshot.data()['bar']['ingredients'];
//     ingredients.add(ingredientId);
//     await usersCollection.doc(user.uid)
//           .update({'bar.ingredients': ingredients});
//   }
// }
