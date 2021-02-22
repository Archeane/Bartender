import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bartender/model/cocktail.dart';

import 'package:bartender/model/ingredient.dart';
import 'package:bartender/widgets/customzie_cocktail_screen/ingredients_input_list.dart';
import 'package:bartender/widgets/customzie_cocktail_screen/receipe_image_picker.dart';
import 'package:bartender/widgets/customzie_cocktail_screen/prepstep_input_list.dart';
import 'package:bartender/screens/community_cocktail_detail_screen.dart';

class CustomizeCocktailScreen extends StatefulWidget {
  final Cocktail cocktail;

  CustomizeCocktailScreen(this.cocktail);

  @override
  _CustomizeCocktailScreenState createState() =>
      _CustomizeCocktailScreenState();
}

class _CustomizeCocktailScreenState extends State<CustomizeCocktailScreen> {
  /**
   * TODO: 
   * 4. ingredient dropdown selections populate with subsitute ingredients
   *      - should not contain duplicates of existing ingredients
   *      - only ingredients of the same type will be shown 
   *      - each ingredient will be fetched onFormSaved
   *      a. populate dropdown menu with other ingredients in the same collection
   *      b. when a user adds a new ingredient, optimally they can select ingredient type and corresponding ingredients will be fetched,
   *          or show all ingredients with a search bar
   *      c. no need to fetch the ingredient - just save the communityCocktail Object to firestore 
   * 5. populate name field with username
   */

  List<Ingredient> _ingredientsList;
  List<String> _prepStepsList;
  bool _isPublic;
  CommunityCocktail _customCocktail;
  final _form = GlobalKey<FormState>();
  File _userImageFile;

  @override
  void initState() {
    super.initState();
    _customCocktail = CommunityCocktail(
      name: "Custom ${widget.cocktail.name}",
      originalCocktailId: widget.cocktail.id,
      ingredients: widget.cocktail.ingredients,
      prepSteps: widget.cocktail.prepSteps,
    );
    _ingredientsList = _customCocktail.ingredients;
    _prepStepsList = _customCocktail.prepSteps;
    _isPublic = false;
  }

  void _addIngredient() => setState(
      () => _ingredientsList = [..._ingredientsList, Ingredient.empty()]);
  void _addPrepStep() =>
      setState(() => _prepStepsList = [..._prepStepsList, null]);
  void _deleteIngredient() => setState(() => _ingredientsList.removeLast());
  void _deletePrepStep() => setState(() => _prepStepsList.removeLast());

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _saveRecipeName(String val) => _customCocktail.name = val;

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    if (_ingredientsList.length == 0 || _prepStepsList.length == 0) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Form Invalid'),
          content: _ingredientsList.length == 0 
            ? const Text('Please add at least one ingredient')
            : const Text("Please add at least one prepreation step"),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    _customCocktail.ingredients = _ingredientsList;
    _customCocktail.prepSteps = _prepStepsList;
    if(_userImageFile == null){
      _customCocktail.imageUrl = widget.cocktail.imageUrl;
    }
    Map<String, dynamic> jsonData = _customCocktail.toJson();
    // save to own collection
    final customCollection = FirebaseFirestore.instance
          .collection('users').doc("FTNuvRC3FSfjN9aH4kbn")
          .collection("custom");
    customCollection.add(jsonData);
    //save to public collection
    if(_isPublic){
      final communityCollection = FirebaseFirestore.instance.collection('community');
      communityCollection.add(jsonData);
    }
    //redirect to custom cocktail page
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CommunityCocktailDetailScreen(_customCocktail),));
  }

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(
          title: Text('Customize Cocktail'),
          actions: <Widget>[
            FlatButton(
              child: Text("Done", style: TextStyle(color: Colors.white)),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Container(
                      child: ReceipeImagePicker(_pickedImage, _saveRecipeName),
                    ),
                    Row(children: [
                      Expanded(
                          child: Text(
                              "Allow my reciepe to be shown to the community")),
                      CupertinoSwitch(
                        value: _isPublic,
                        onChanged: (val) {
                          _customCocktail.isPublic = val;
                          setState(() => _isPublic = val);
                        },
                      ),
                    ]),
                    
                    Container(
                      child: IngredientsInputList(
                          _ingredientsList, _deleteIngredient, _addIngredient),
                    ),
                    Container(
                        child: PrepstepInputList(
                            _prepStepsList, _deletePrepStep, _addPrepStep)),
                    Text("Notes", style: textThemes.headline4),
                    SizedBox(height: 10,),
                    Container(
                      height: 100,
                      child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: "Add Notes..."),
                          style: TextStyle(fontSize: 16),
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          onSaved: (val) {
                            _customCocktail.notes = val;
                          }),
                    ),
                  ],
                ),
              )),
        ));
  }
}
