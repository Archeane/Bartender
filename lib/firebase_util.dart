import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './model/ingredient.dart';

class InvalidArgumentException implements Exception {
  String error;
  InvalidArgumentException(this.error);
}


CollectionReference ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
CollectionReference usersCollection = FirebaseFirestore.instance.collection('users'); 
final user = FirebaseAuth.instance.currentUser;
    // 

Future<Ingredient> fetchIngredientById(String id) async {
  DocumentSnapshot snapshot = await ingredientsCollection.doc(id).get();
  if (snapshot.exists) {
    final data = snapshot.data();
    var temp = Ingredient(
      id: id,
      name: data['name']
    );
    print(temp);
    return temp;
  }
  throw new InvalidArgumentException("$id does not exist");
}

Future<List<Ingredient>> fetchMybarIngredients() async {
  List<Ingredient> ingredients = new List<Ingredient>();
  DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
  if(userSnapshot.exists){
    final userData = userSnapshot.data();
    for(var ingredientId in userData['bar']['ingredients']){
      print(ingredientId);
      Ingredient doc = await fetchIngredientById(ingredientId);
      ingredients.add(doc);
    }
  }
  return ingredients;
}

Future<List<dynamic>> getMyBarIngredients() async {
  DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
  if(userSnapshot.exists){
    return userSnapshot.data()['bar']['ingredients'];
  }
  return null;
}

Future<List<Ingredient>> fetchAllIngredients() async {
  List<Ingredient> ingredients = new List<Ingredient>();
  QuerySnapshot snapshot = await ingredientsCollection.get();
  for(var doc in snapshot.docs){
      ingredients.add(Ingredient.fromFirebaseSnapshot(doc.id, doc));
  }
  return ingredients;
}

Future<void> addIngredientToMyBar(String ingredientId) async {
  DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
  if(userSnapshot.exists){
    final ingredients = userSnapshot.data()['bar']['ingredients'];
    ingredients.add(ingredientId);
    await usersCollection.doc(user.uid)
          .update({'bar.ingredients': ingredients});
  }
}

Future<void> removeIngredientFromMyBar(String ingredientId) async {
  DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();
  if(userSnapshot.exists){
    final ingredients = userSnapshot.data()['bar']['ingredients'];
    int index = ingredients.indexOf(ingredientId);
    ingredients.removeAt(index);
    await usersCollection.doc(user.uid)
          .update({'bar.ingredients': ingredients});
  }
}