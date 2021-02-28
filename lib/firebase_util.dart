
import 'package:bartender/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import './model/ingredient.dart';
import 'package:bartender/user_firebase_util.dart';

class InvalidArgumentException implements Exception {
  String error;
  InvalidArgumentException(this.error);
}

bool isInit = false;
CollectionReference ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
List<Ingredient> allIngredients;

Future<void> init() async {
  if(!isInit){
    allIngredients = await fetchAllIngredients();
    
    print("loaded allingredients in init()");
    print(allIngredients);
    isInit = true;
  }
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
// }

// Future<List<dynamic>> getMyBarIngredients() async {
//   DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
//   if(userSnapshot.exists){
//     return userSnapshot.data()['bar']['ingredients'];
//   }
//   return null;
// }

Future<List<Ingredient>> fetchAllIngredients() async {
  List<Ingredient> ingredients = new List<Ingredient>();
  QuerySnapshot snapshot = await ingredientsCollection.get();
  for(var doc in snapshot.docs){
      ingredients.add(Ingredient.fromFirebaseSnapshot(doc.id, doc));
  }
  return ingredients;
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
